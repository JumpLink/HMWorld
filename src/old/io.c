/**
 * @file
 * Ein-/Ausgabe-Modul.
 * Das Modul kapselt die Ein- und Ausgabe-Funktionalitaet (insbesondere die GLUT-
 * Callbacks) des Programms.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */
#ifdef MACOSX
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

/* ---- Eigene Header einbinden ---- */
#include "io.h"
#include "logic.h"
#include "scene.h"
#include "types.h"
#include "consts.h"
#include "functions.h"

/* ---- Funktionen ---- */

/**
 * Setzen der Projektionsmatrix.
 * Setzt die Projektionsmatrix fuer die Szene.
 *
 * @param aspect Seitenverhaeltnis des Anzeigefensters (In).
 */
static void setProjection (GLdouble aspect)
{
	/* Nachfolgende Operationen beeinflussen Projektionsmatrix */
	glMatrixMode (GL_PROJECTION);
	/* Matrix zuruecksetzen - Einheitsmatrix laden */
	glLoadIdentity ();

    /* Ortho-Projektion, Koordinatensystem bleibt quadratisch */
	if (aspect <= 1) {
		gluOrtho2D (-1.0, 1.0,                    /* links, rechts */
		            -1.0 / aspect, 1.0 / aspect); /* unten, oben */
	} else {
		gluOrtho2D (-1.0 * aspect, 1.0 * aspect,  /* links, rechts */
		            -1.0, 1.0);                   /* unten, oben */
	}
}

/**
 * Umschalten zw. Vollbild- und Fenstermodus.
 * Beim Wechsel zum Fenstermodus wird vorherige Position und Groesse
 * wiederhergestellt. HINWEIS: Fenster wird nicht korrekt auf alte Position
 * gesetzt, da GLUT_WINDOW_WIDTH/HEIGHT verfaelschte Werte liefert.
 */
void toggleFullscreen (void)
{
	/* Flag: Fullscreen: ja/nein */
	static GLboolean fullscreen = GL_FALSE;
	/* Zwischenspeicher: Fensterposition */
	static Point2i windowPos;
	/* Zwischenspeicher: Fenstergroesse */
	static Dimensions2i windowSize;

	/* Modus wechseln */
	fullscreen = !fullscreen;

	if (fullscreen) {
		/* Fenstereinstellungen speichern */
		windowPos[0] = glutGet (GLUT_WINDOW_X);
		windowPos[1] = glutGet (GLUT_WINDOW_Y);
		windowSize[0] = glutGet (GLUT_WINDOW_WIDTH);
		windowSize[1] = glutGet (GLUT_WINDOW_HEIGHT);
		/* In den Fullscreen-Modus wechseln */
		glutFullScreen ();
	} else {
		/* alte Fenstereinstellungen wiederherstellen */
		glutReshapeWindow (windowSize[0], windowSize[1]);

		/* HINWEIS:
		   Auskommentiert, da es sonst Probleme mit der Vollbildarstellung bei
		   Verwendung von FreeGlut gibt */
		glutPositionWindow (windowPos[0], windowPos[1]);
	}
}

/**
 * Timer-Callback.
 * Initiiert Berechnung der aktuellen Position und Farben und anschliessendes
 * Neuzeichnen, setzt sich selbst erneut als Timer-Callback.
 *
 * @param lastCallTime Zeitpunkt, zu dem die Funktion als Timer-Funktion
 *   registriert wurde (In).
 */
static void cbTimer (int lastCallTime)
{
	/* Seit dem Programmstart vergangene Zeit in Millisekunden */
	int thisCallTime = glutGet (GLUT_ELAPSED_TIME);
	/* Seit dem letzten Funktionsaufruf vergangene Zeit in Sekunden */
	double interval = (double) (thisCallTime - lastCallTime) / 1000.0f;

	/* neue Position berechnen (zeitgesteuert) */
	doLogic (interval);

	/* Wieder als Timer-Funktion registrieren, falls nicht pausiert */
	if(!getStatus()->paused)
		glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);

	/* Neuzeichnen anstossen */
	glutPostRedisplay ();
}

/**
 * Verarbeitung eines Tasturereignisses.
 * s: Flieger starten lassen
 * n: Normalen umschalten
 * c: Zeichnen der konvexen Huelle umschalten
 * b: Umschalten zwischen Spline / Bezier.
 * +/-: Splinezeichendetail erhoehen / verringern
 * F1: Wireframemodus umschalten
 * F2: Vollbildmodus umschalten
 * h: Hilfefenster einblenden
 * p: Pausieren
 * q,ESC: Beenden
 *
 * @param key Taste, die das Ereignis ausgeloest hat. (ASCII-Wert oder WERT des
 *        GLUT_KEY_<SPECIAL>.
 * @param status Status der Taste, GL_TRUE=gedrueckt, GL_FALSE=losgelassen.
 * @param isSpecialKey ist die Taste eine Spezialtaste?
 * @param x x-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
 * @param y y-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
 */
static void handleKeyboardEvent (int key, int status, GLboolean isSpecialKey, int x, int y)
{
/** Keycode der ESC-Taste */
#define ESC 27

	/* Taste gedrueckt */
	if (status == GLUT_DOWN) {
		/* nicht-Spezialtasten */
		if (!isSpecialKey) {
			switch (key) {
				/* Leertaste: Level fortfahren/neustarten */
				case ' ':
					progressRestartLevel();
					break;
				/* Flieger starten */
				case 's':
				case 'S':
					startFlight();
					break;
				/* Normalen umschalten */
				case 'n':
				case 'N':
					toggleNormals();
					break;
				/* Konvexe Huelle umschalten */
				case 'c':
				case 'C':
					toggleConvex();
					break;
				/* Spline / Bezier umschalten */
				case 'b':
				case 'B':
					toggleType();
					break;
				/* Detailstufe erhoehen */
				case '+':
					increaseSplineDetail();
					break;
				/* Detailstufe senken */
				case '-':
					decreaseSplineDetail();
					break;
				/* Hilfe umschalten */
				case 'h':
				case 'H':
					toggleHelp();
					break;
				/* Pause umschalten */
				case 'p':
				case 'P':
					togglePause();
					/* Wenn Pause ausgeschaltet, Timercallback neu registrieren */
					if(!getStatus()->paused) {
						int thisCallTime = glutGet (GLUT_ELAPSED_TIME);
						glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);
					}
					break;
				/* Programm beenden */
				case 'q':
				case 'Q':
				case ESC:
					cleanupLogic();
					exit (0);
					break;
			}
		/* Spezialtasten */
		} else {
			switch (key) {
				/* (De-)Aktivieren des Wireframemode */
				case GLUT_KEY_F1:
					toggleWireframeMode ();
					glutPostRedisplay ();
					break;
				/* Umschalten Vollbildmodus */
				case GLUT_KEY_F2:
					toggleFullscreen ();
					glutPostRedisplay ();
					break;
			}
		}
	}
}

/**
 * Callback fuer Tastendruck.
 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
 *
 * @param key betroffene Taste (In).
 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
 */
static void cbKeyboard (unsigned char key, int x, int y)
{
	handleKeyboardEvent (key, GLUT_DOWN, GL_FALSE, x, y);
}

/**
 * Callback fuer Druck auf Spezialtasten.
 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
 *
 * @param key betroffene Taste (In).
 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
 */
static void cbSpecial (int key, int x, int y)
{
	handleKeyboardEvent (key, GLUT_DOWN, GL_TRUE, x, y);
}

/**
 * Aktualisieren der Koordinate eines verschoben werdenden Punktes
 *
 * @param x Mauskoordinate in x
 * @param y Mauskoordinate in y
 */
void updatePickCoords(int x, int y)
{
	GameStatus * s = getStatus();
	Vector2d m;
	GLdouble xrel, yrel;
	GLdouble aspect = (double) glutGet (GLUT_WINDOW_WIDTH) /
	                  (double) glutGet (GLUT_WINDOW_HEIGHT);

	/* Mauskoordinaten umwandeln in Modellkoordinaten */
	y = glutGet(GLUT_WINDOW_HEIGHT) - y - 1;
	if (aspect > 1.0f) {
		xrel = 2.0 / glutGet(GLUT_WINDOW_WIDTH) * aspect;
		yrel = 2.0 / glutGet(GLUT_WINDOW_HEIGHT);
		m[cX] = x * xrel - 1.0f * aspect;
		m[cY] = y * yrel - 1.0f;
	} else {
		xrel = 2.0 / glutGet(GLUT_WINDOW_WIDTH);
		yrel = 2.0 / glutGet(GLUT_WINDOW_HEIGHT) / aspect;
		m[cX] = x * xrel - 1.0f;
		m[cY] = y * yrel - 1.0f / aspect;
	}

	/* Kreismittelpunkt an diese Koordinaten schieben */
	s->level.spline.basePoints[s->picked][cX] = m[cX];
	s->level.spline.basePoints[s->picked][cY] = m[cY];

	/* Splinekurve entsprechend anpassen */
	reticulateSplines();
}

/**
 * Picken der verschiebbaren Punkte
 *
 * @param x Mauskoordinate in x
 * @param y Mauskoordinate in y
 */
void pick(int x, int y)
{
	GLuint i;
	GameStatus * s = getStatus();
	Vector2d * c = s->level.spline.basePoints;
	Vector2d m;
	GLdouble xrel, yrel;
	GLdouble aspect = (double) glutGet (GLUT_WINDOW_WIDTH) /
	                  (double) glutGet (GLUT_WINDOW_HEIGHT);

	/* Mauskoordinaten umwandeln in Modellkoordinaten */
	y = glutGet(GLUT_WINDOW_HEIGHT) - y - 1;
	if (aspect > 1.0f) {
		xrel = 2.0 / glutGet(GLUT_WINDOW_WIDTH) * aspect;
		yrel = 2.0 / glutGet(GLUT_WINDOW_HEIGHT);
		m[cX] = x * xrel - 1.0f * aspect;
		m[cY] = y * yrel - 1.0f;
	} else {
		xrel = 2.0 / glutGet(GLUT_WINDOW_WIDTH);
		yrel = 2.0 / glutGet(GLUT_WINDOW_HEIGHT) / aspect;
		m[cX] = x * xrel - 1.0f;
		m[cY] = y * yrel - 1.0f / aspect;
	}

	/* Pruefen, ob diese Koordinaten im Kreis liegen (sqr(c[cX]-x)+sqr(c[cY]-y)<=r */
	for (i=1;i<s->level.spline.baseCount-1;++i)
		if (checkColCircleCircle(c[i],m,SPLINE_BASE_RADIUS,0))
			s->picked=i;
}

/**
 * Verarbeitung eines Mausereignisses.
 * linke Maustaste: verschieben eines Kontrollpunktes.
 *
 * @param x x-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
 * @param y y-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
 * @param eventType Typ des Ereignisses.
 * @param button ausloesende Maustaste (nur bei Ereignissen vom Typ mouseButton).
 * @param buttonState Status der Maustaste (nur bei Ereignissen vom Typ mouseButton).
 */
void handleMouseEvent (int x, int y, MouseEventType eventType, int button,
                       int buttonState)
{
	switch (eventType) {
		case mouseButton:
			switch (button) {
				case GLUT_LEFT_BUTTON:
					/* Picking der Kontrollpunkte mit linker Maustaste */
					if (buttonState == GLUT_DOWN) {
						if(getStatus()->picked == 0)
							pick(x,y);
					} else
						getStatus()->picked = 0;
					break;
				case GLUT_RIGHT_BUTTON:
					if (buttonState == GLUT_UP)
						toggleHelp();
					else
						toggleHelp();
					break;
			}
			break;
		/* Mausbewegung: gepicktes Objekt aktualisieren */
		case mouseMotion:
			if (getStatus()->picked != 0)
				updatePickCoords(x,y);
			break;
	}
}

/**
 * Mouse-Button-Callback.
 *
 * @param button Taste, die den Callback ausgeloest hat.
 * @param state Status der Taste, die den Callback ausgeloest hat.
 * @param x X-Position des Mauszeigers beim Ausloesen des Callbacks.
 * @param y Y-Position des Mauszeigers beim Ausloesen des Callbacks.
 */
void cbMouseButton (int button, int state, int x, int y)
{
	handleMouseEvent (x, y, mouseButton, button, state);
}

/**
 * Mouse-Motion-Callback.
 *
 * @param x X-Position des Mauszeigers beim Ausloesen des Callbacks.
 * @param y Y-Position des Mauszeigers beim Ausloesen des Callbacks.
 */
void cbMouseMotion (int x, int y)
{
	handleMouseEvent (x, y, mouseMotion, 0, 0);
}

/**
 * Callback fuer Aenderungen der Fenstergroesse.
 * Initiiert Anpassung der Projektionsmatrix an veränderte Fenstergroesse.
 * @param w Fensterbreite (In).
 * @param h Fensterhoehe (In).
 */
static void cbReshape (int w, int h)
{
	/* Das ganze Fenster ist GL-Anzeigebereich */
	glViewport (0, 0, (GLsizei) w, (GLsizei) h);

	/* Anpassen der Projektionsmatrix an das Seitenverhältnis des Fensters */
	setProjection ((GLdouble) w / (GLdouble) h);
}

/**
 * Zeichen-Callback.
 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
 * und Backbuffer.
 */
static void cbDisplay (void)
{
	/* Colorbuffer leeren */
	glClear (GL_COLOR_BUFFER_BIT);

	/* Nachfolgende Operationen beeinflussen Modelviewmatrix */
	glMatrixMode (GL_MODELVIEW);

	/* Szene zeichnen */
	drawScene ();

	/* Szene anzeigen / Buffer tauschen */
	glutSwapBuffers ();
}

/**
 * Registrierung der GLUT-Callback-Routinen.
 */
static void registerCallbacks (void)
{
	/* Tasten-Druck-Callback - wird ausgefuehrt, wenn eine Taste gedrueckt wird */
	glutKeyboardFunc (cbKeyboard);

	/* Spezialtasten-Druck-Callback - wird ausgefuehrt, wenn Spezialtaste
	 * (F1 - F12, Links, Rechts, Oben, Unten, Bild-Auf, Bild-Ab, Pos1, Ende oder
	 * Einfuegen) gedrueckt wird */
	glutSpecialFunc (cbSpecial);

	/* Mouse-Button-Callback (wird ausgefuehrt, wenn eine Maustaste
	 * gedrueckt oder losgelassen wird) */
	glutMouseFunc (cbMouseButton);

	/* Mausbewegungs-Callback bei gedrueckter Taste */
	glutMotionFunc (cbMouseMotion);

	/* Timer-Callback - wird einmalig nach msescs Millisekunden ausgefuehrt */
	glutTimerFunc (1000 / TIMER_CALLS_PS,         /* msecs - bis Aufruf von func */
				   cbTimer,                       /* func  - wird aufgerufen    */
				   glutGet (GLUT_ELAPSED_TIME));  /* value - Parameter, mit dem
												   func aufgerufen wird */

	/* Reshape-Callback - wird ausgefuehrt, wenn neu gezeichnet wird (z.B. nach
	 * Erzeugen oder Groessenaenderungen des Fensters) */
	glutReshapeFunc (cbReshape);

	/* Display-Callback - wird an mehreren Stellen imlizit (z.B. im Anschluss an
	 * Reshape-Callback) oder explizit (durch glutPostRedisplay) angestossen */
	glutDisplayFunc (cbDisplay);
}

/**
 * Initialisiert das Programm (inkl. I/O und OpenGL) und startet die
 * Ereignisbehandlung.
 *
 * @param title Beschriftung des Fensters
 * @param width Breite des Fensters
 * @param height Hoehe des Fensters
 * @return ID des erzeugten Fensters, 0 im Fehlerfall
 */
int initAndStartIO (char *title, int width, int height)
{
	int windowID = 0;

	/* Kommandozeile immitieren */
	int argc = 1;
	char *argv = "cmd";

	/* Glut initialisieren */
	glutInit (&argc, &argv);

	/* Initialisieren des Fensters */
	/* RGB-Framewbuffer, Double-Buffering und z-Buffer anfordern */
	glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	glutInitWindowSize (width, height);
	glutInitWindowPosition (0, 0);

	/* Fenster erzeugen */
	windowID = glutCreateWindow (title);

	if (windowID) {
		/* Logik initialisieren */
		initLogic ();
		/* Szene initialisieren */
		if (initScene ()) {
			/* Callbacks registrieren */
			registerCallbacks ();
			/* Eintritt in die Ereignisschleife */
			glutMainLoop ();
		} else {
			/* Szene konnte nicht initialisiert werden */
			glutDestroyWindow (windowID);
			windowID = 0;
		}
	} else {
		/* Fenster konnte nicht erzeugt werden */
	}

	return windowID;
}
