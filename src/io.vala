using GL;
using GLU;
using GLUT;

namespace IO {

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
		//double interval = (double) (thisCallTime - lastCallTime) / 1000.0f;

		/* neue Position berechnen (zeitgesteuert) */
		//doLogic (interval);

		/* Wieder als Timer-Funktion registrieren, falls nicht pausiert */
		//if(!getStatus()->paused)
			glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);

		/* Neuzeichnen anstossen */
		glutPostRedisplay ();
	}

	/**
	 * Zeichen-Callback.
	 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
	 * und Backbuffer.
	 */
	static void cbDisplay ()
	{
		/* Colorbuffer leeren */
		glClear (GL_COLOR_BUFFER_BIT);

		/* Nachfolgende Operationen beeinflussen Modelviewmatrix */
		glMatrixMode (GL_MODELVIEW);

		/* Szene zeichnen */
		// OpenGL rendering goes here...
		    glBegin (GL_QUADS);
		        glVertex3f ( -1.0f,  1.0f, 0.0f);
		        glVertex3f (  1.0f,  1.0f, 0.0f);
		        glVertex3f (  1.0f, -1.0f, 0.0f);
		        glVertex3f ( -1.0f, -1.0f, 0.0f);
		    glEnd ();


		/* Szene anzeigen / Buffer tauschen */
		glutSwapBuffers ();
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
		print("test!");
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
	static void handleKeyboardEvent (int key, GL.GLenum status, bool isSpecialKey, int x, int y)
	{
		/* Taste gedrueckt */
		if (status == GLUT_DOWN) {
			/* nicht-Spezialtasten */
			if (!isSpecialKey) {
				switch (key) {
					/* Programm beenden */
					case 'q':
					case 'Q':
					case ESC:
						//cleanupLogic();
						//exit (0);
						print("Jetzt sollte egtl. das Programm beendet werden..");
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
	static void cbKeyboard ( uchar key, int x, int y)
	{
		handleKeyboardEvent (key, GLUT_DOWN, false, x, y);
	}

	/**
	 * Registrierung der GLUT-Callback-Routinen.
	 */
	static void registerCallbacks ()
	{
		/* Tasten-Druck-Callback - wird ausgefuehrt, wenn eine Taste gedrueckt wird */
		glutKeyboardFunc (cbKeyboard);

		/* Spezialtasten-Druck-Callback - wird ausgefuehrt, wenn Spezialtaste
		 * (F1 - F12, Links, Rechts, Oben, Unten, Bild-Auf, Bild-Ab, Pos1, Ende oder
		 * Einfuegen) gedrueckt wird */
		//glutSpecialFunc (cbSpecial);

		/* Mouse-Button-Callback (wird ausgefuehrt, wenn eine Maustaste
		 * gedrueckt oder losgelassen wird) */
		//glutMouseFunc (cbMouseButton);

		/* Mausbewegungs-Callback bei gedrueckter Taste */
		//glutMotionFunc (cbMouseMotion);

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
	bool initAndStartIO (string title, int width, int height)
	{
		int windowID = 0;

		/* Kommandozeile immitieren */
		int argc = 1;
		string[] argv = {"cmd"};

		/* Glut initialisieren */
		glutInit (ref argc, argv);

		/* Initialisieren des Fensters */
		/* RGB-Framewbuffer, Double-Buffering und z-Buffer anfordern */
		glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
		glutInitWindowSize (width, height);
		glutInitWindowPosition (0, 0);

		/* Fenster erzeugen */
		windowID = glutCreateWindow (title);

		if (windowID != 0) {
			/* Logik initialisieren */
			//initLogic ();
			/* Szene initialisieren */
			//if (initScene ()) {
				/* Callbacks registrieren */
				registerCallbacks ();
				/* Eintritt in die Ereignisschleife */
				glutMainLoop ();
			//} else {
			//	/* Szene konnte nicht initialisiert werden */
			//	glutDestroyWindow (windowID);
			//	windowID = 0;
			//}
		} else {
			/* Fenster konnte nicht erzeugt werden */
		}

		return windowID != 0;
	}
}
