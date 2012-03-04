/**
 * @file
 * Darstellungs-Modul.
 * Das Modul kapselt die Rendering-Funktionalitaet (insbesondere der OpenGL-
 * Aufrufe) des Programms.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */
#include <stdarg.h>
#include <stdio.h>
#ifdef MACOSX
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

/* ---- Eigene Header einbinden ---- */
#include "scene.h"
#include "logic.h"
#include "types.h"
#include "consts.h"

/* ---- Farbkonstanten ---- */

/** Szenenhintergrundfarbe */
static Color4f colBG = {0.6f, 0.6f, 1.0f, 0.0f};
/** Hilfebox-Textfarbe (orange) */
static Color3f colHelpText = {0.8f, 0.4f, 0.0f};
/** Hilfebox-Hintergrundfarbe (hellgruen semitransparent) */
static Color4f colHelpBack = {0.6f, 1.0f, 6.0f, 0.7f};
/** Gewonnen-Box Hintergrund (gruen-semitransparent) */
static Color4f colWonBack = {0.0f, 1.0f, 0.0f, 0.7f};
/** Verloren-Box Hintergrund (rot-semitransparent) */
static Color4f colLostBack = {1.0f, 0.0f, 0.0f, 0.7f};
/** Gewonnen/Verloren-Box Text (weiss) */
static Color3f colWonLostText = {1.0f, 1.0f, 1.0f};

/** Farbe von starren Stuetzpunkten */
static Color3f colBaseFix = {0.3f, 0.3f, 0.3f};
/** Farbe von beweglichen Kontrollpunkten */
static Color3f colBaseMove = {0.6f, 0.3f, 0.3f};

/** Farbe vom Flugzeug (weiss) */
static Color3f colPlane = {1.0f, 1.0f, 1.0f};
/** Farbe von Sternen (gelb) */
static Color3f colStar = {1.0f, 1.0f, 0.0f};
/** Farbe von Wolken (grau) */
static Color3f colCloud = {0.5f, 0.5f, 0.5f};

/** Farbe der Normalen (blau) */
static Color3f colNormal = {0.0f, 0.0f, 1.0f};
/** Farbe der Konvexen Huelle (rot) */
static Color3f colConvex = {1.0f, 0.0f, 0.0f};
/** Farbe der Spline (schwarz) */
static Color3f colSpline = {0.0f, 0.0f, 0.0f};

/* ---- Funktionen ---- */

/* --- Text, Menue, Hilfe --- */

/**
 * Zeichnen einer Zeichfolge in den Vordergrund. Gezeichnet wird mit Hilfe von
 * <code>glutBitmapCharacter(...)</code>. Kann wie <code>printf genutzt werden.</code>
 *
 * @param x x-Position des ersten Zeichens 0 bis 1 (In).
 * @param y y-Position des ersten Zeichens 0 bis 1 (In).
 * @param color Textfarbe (In).
 * @param font Schriftart
 * @param format Formatstring fuer die weiteren Parameter (In).
 */
void drawString (GLfloat x, GLfloat y, GLfloat * color, void *font, char *format, ...)
{
	va_list args;                 /* variabler Teil der Argumente */
	char buffer[255];             /* der formatierte String */
	char *s;                      /* Zeiger/Laufvariable */
	va_start (args, format);
	vsprintf (buffer, format, args);
	va_end (args);

	/* neue Zeichenfarbe einstellen */
	glColor4fv (color);

	/* an uebergebenene Stelle springen */
	glRasterPos2f (x, y);

	/* Zeichenfolge zeichenweise zeichnen */
	for (s = buffer; *s; s++)
		glutBitmapCharacter (font, *s);
}

/**
 * Zeichnet ein 2d-Rechteck mit der Seitenlaenge 1 im Ursprung.
 */
void draw2dRect()
{
	glBegin(GL_QUADS);
		glVertex2d(-0.5f, 0.5f);
		glVertex2d(-0.5f,-0.5f);
		glVertex2d( 0.5f,-0.5f);
		glVertex2d( 0.5f, 0.5f);
	glEnd();
}

/**
 * Zeichnet die Pausen/Hilfebox mit Tastaturbelegung
 */
void drawHelpBox(void)
{
	/* Hintergrundbox zeichnen */
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glPushMatrix();
		glScaled(1.2f,1.5f,0.0f);
		glColor4fv(colHelpBack);
		draw2dRect(1.5f,1.5f);
	glPopMatrix();
	glDisable(GL_BLEND);

	/* Box mit Hilfetext befuellen */
	drawString(-0.40f,0.60f, colHelpText, GLUT_BITMAP_HELVETICA_12,
	           "Tastaturbelegung:");

	drawString(-0.40f,0.44f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "Maustaste links: Kontrollpunkte verschieben");
	drawString(-0.40f,0.36f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "s: Flieger starten");

	drawString(-0.40f,0.20f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "n: Normalenzeichnen umschalten");
	drawString(-0.40f,0.12f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "c: Zeichnen der konvexen Huelle umschalten");
	drawString(-0.40f,0.04f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "b: Umschalten Spline- / Bezierinterpolation");
	drawString(-0.40f,-0.04f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "+/-: Splinezeichendetail erhoehen / verringern");
	drawString(-0.40f,-0.12f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "F1: Wireframemodus umschalten");
	drawString(-0.40f,-0.20f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "F2: Vollbildmodus umschalten");

	drawString(-0.40f,-0.36f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "p: Pause umschalten");
	drawString(-0.40f,-0.44f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "h: Hilfe umschalten");

	drawString(-0.40f,-0.60f, colHelpText, GLUT_BITMAP_HELVETICA_10,
	           "q/ESC: Programm beenden");
}

/**
 * Zeichnet einen Hinweis, dass die Szene pausiert ist.
 */
void drawPauseIndicator (void)
{
	drawString(-0.9f,-0.9f, colHelpText, GLUT_BITMAP_HELVETICA_18,
	           "PAUSIERT");
}

/**
 * Gewonnen-Hinweis zeigen
 */
void drawWonIndicator (void)
{
	/* Hintergrundbox zeichnen */
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glPushMatrix();
		glScaled(1.5f,0.5f,0.0f);
		glColor4fv(colWonBack);
		draw2dRect(1.5f,1.5f);
	glPopMatrix();
	glDisable(GL_BLEND);

	drawString(-0.20f,0.1f, colWonLostText, GLUT_BITMAP_HELVETICA_18,
	           "Gewonnen!");
	drawString(-0.25f,-0.1f, colWonLostText, GLUT_BITMAP_HELVETICA_12,
	           "Fortfahren mit Space!");
}

/**
 * Verloren-Hinweis zeigen
 */
void drawLostIndicator (void)
{
	/* Hintergrundbox zeichnen */
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glPushMatrix();
		glScaled(1.5f,0.5f,0.0f);
		glColor4fv(colLostBack);
		draw2dRect(1.5f,1.5f);
	glPopMatrix();
	glDisable(GL_BLEND);

	drawString(-0.20f,0.1f, colWonLostText, GLUT_BITMAP_HELVETICA_18,
	           "Verloren!");
	drawString(-0.30f,-0.1f, colWonLostText, GLUT_BITMAP_HELVETICA_12,
	           "Neuversuch mit Space!");
}

/* --- Szene / Objekte --- */

/**
 * Zeichnet einen Kreis in den Ursprung
 *
 * @param radius Radius des Kreises
 */
void drawCircle(GLdouble radius)
{
	GLUquadric * quad = gluNewQuadric();
	gluDisk(quad,0.0f,radius,CIRCLE_DETAIL,CIRCLE_DETAIL);
	gluDeleteQuadric(quad);
}

/**
 * Zeichnet Stuetzpunkte bzw Kontrollpunkte der Kurve.
 *
 * @param c Koordinaten des Kontrollpunktes
 * @param fixed Flag, ob der Punkt fix oder beweglich ist.
 */
void drawBasePoint(Vector2d c, GLuint fixed)
{
	glColor3fv(fixed?colBaseFix:colBaseMove);
	glPushMatrix();
		glTranslated(c[cX],c[cY],0.0f);
		drawCircle(SPLINE_BASE_RADIUS);
	glPopMatrix();
}

/**
 * Zeichnet die Entities
 * (Flieger, Sterne, Wolken)
 *
 * @param l Leveldaten.
 */
void drawEntities (Level * l)
{
	GLuint i;
	for (i = 0; i < l->entityCount; ++i) {
		glPushMatrix();
		glTranslated(l->entities[i].center[cX],
		             l->entities[i].center[cY],
		             0.0f);
		glRotated(l->entities[i].arc,0,0,1);
		switch (l->entities[i].type) {
			case entPlane:
				glColor3fv(colPlane);
				break;
			case entCloud:
				glColor3fv(colCloud);
				break;
			case entStar:
				glColor3fv(colStar);
				break;
			default:
				break;
		}
		if (l->entities[i].type != entNull)
			drawCircle(l->entities[i].radius);
		glPopMatrix();
	}
}

/**
 * Zeichenfunktion
 * Zeichnet die Splinekurve.
 *
 * @param s Splinekurve
 */
void drawSpline (Spline * s)
{
	glColor3fv(colSpline);
	glDrawElements(GL_LINE_STRIP, s->splineIndexCount, GL_UNSIGNED_INT, s->splineIndices);
}

/**
 * Zeichenfunktion
 * Zeichnet die Normalen der Splinekurve.
 *
 * @param s Splinekurve
 */
void drawNormals (Spline * s)
{
	glColor3fv(colNormal);
	glDrawElements(GL_LINES, s->normalIndexCount, GL_UNSIGNED_INT, s->normalIndices);
}

/**
 * Zeichnet die konvexe Huelle
 *
 * @param s Splinekurve
 */
void drawConvexHull(Spline * s)
{
	GLuint i;
	glColor3fv(colConvex);
	glBegin(GL_LINE_LOOP);
		for(i = 0; i < s->hullIndexCount; ++i)
			glVertex2dv(s->basePoints[s->hullIndices[i]]);
	glEnd();
}

/**
 * Zeichenfunktion.
 * Stellt die komplette Szene dar.
 */
void drawScene (void)
{
	GLuint i;
	Level * l = getLevel();

	/* Entities zeichnen */
	drawEntities(l);

	/* Stuetzpunkte bzw Kontrollpunkte zeichnen */
	for(i=0;i<l->spline.baseCount;++i)
		drawBasePoint(l->spline.basePoints[i], i==0 || i==l->spline.baseCount-1);

	/* Konvexe Huelle zeichnen */
	if(l->spline.convex)
		drawConvexHull(&l->spline);

	/* Normalen zeichnen */
	if(getStatus()->normals)
		drawNormals(&l->spline);

	/* Splinekurve zeichnen */
	drawSpline(&l->spline);

	/* Gewonnen / Verloren - Ausgabe */
	if (getStatus()->level.won)
		drawWonIndicator();

	if (getStatus()->level.lost)
		drawLostIndicator();

	/* Hilfeausgabe */
	if (getStatus()->help)
		drawHelpBox();

	/* Pausenindikator */
	if (getStatus()->paused)
		drawPauseIndicator();
}

/**
 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
 * OpenGL-Statusmaschine.
 * @return Rueckgabewert: im Fehlerfall 0, sonst 1.
 */
int initScene (void)
{
	/* Setzen der Farbattribute */
	/* Hintergrundfarbe */
	glClearColor (colBG[cR], colBG[cG], colBG[cB], colBG[cA]);
	/* Zeichenfarbe */
	glColor3f (1.0f, 1.0f, 1.0f);

	/* Vertexarrays erlauben */
	glEnableClientState (GL_VERTEX_ARRAY);

	/* Polygonrueckseiten nicht anzeigen */
	/*glCullFace (GL_BACK);
	glEnable (GL_CULL_FACE);*/

	/* Alles in Ordnung? */
	return (glGetError() == GL_NO_ERROR);
}

/**
 * (De-)aktiviert den Wireframe-Modus.
 */
void toggleWireframeMode (void)
{
	/* Flag: Wireframe: ja/nein */
	static GLboolean wireframe = GL_FALSE;

	/* Modus wechseln */
	wireframe = !wireframe;

	if (wireframe)
		glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
	else
		glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
}
