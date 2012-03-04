/**
 * @file
 * Logik-Modul.
 * Das Modul kapselt die Programmlogik. Wesentliche Programmlogik ist die
 * Verwaltung des Rotationswinkels des Wuerfels. Die Programmlogik ist
 * weitgehend unabhaengig von Ein-/Ausgabe (io.h/c) und
 * Darstellung (scene.h/c).
 *
 * Uebung 01: Wuerfel mit Vertex-Arrays
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/* ---- Eigene Header einbinden ---- */
#include "logic.h"
#include "consts.h"
#include "spline.h"
#include "functions.h"

/* ---- Globale Daten ---- */
static GameStatus g_status;

/* ---- Funktionen ---- */

/**
 * Setzt die Daten des Plane-Entities entsprechend
 * seines Fortschrittes in der Kurve.
 */
void repositionPlane (void)
{
/** Funktionsabstand mit dem die Normale bestimmt werden soll */
#define DIFF 0.01f
	Level * l = &g_status.level;
	GLdouble len;
	Vector2d n;
	/* Normale bestimmen */
	n[cX] = functionAt(l->spline.qy[l->plane.qIndex],l->plane.t+DIFF) -
	        functionAt(l->spline.qy[l->plane.qIndex],l->plane.t-DIFF);
	n[cY] = functionAt(l->spline.qx[l->plane.qIndex],l->plane.t-DIFF) -
			functionAt(l->spline.qx[l->plane.qIndex],l->plane.t+DIFF);
	/* Normieren und strecken auf einheitliche Distanz */
	len = sqrt(sqr(n[cX])+sqr(n[cY]));
	n[cX] /= len; n[cY] /= len;
	l->entities[0].arc = rad2deg(n[cY]<0?2*PI-acos(n[cX]):acos(n[cX]));
	n[cX] *= -PLANE_SPLINE_DISTANCE;
	n[cY] *= -PLANE_SPLINE_DISTANCE;
	/* Neue Koordinaten errechnen aus Funktionswert + Normale */
	l->entities[0].center[cX] =
		functionAt(l->spline.qx[l->plane.qIndex],l->plane.t) + n[cX];
	l->entities[0].center[cY] =
		functionAt(l->spline.qy[l->plane.qIndex],l->plane.t) + n[cY];
}

/* --- Funktionen durch Tastendruck --- */

/**
 * Startet den Flug des Fliegers.
 */
void startFlight(void)
{
	if (!g_status.level.won && !g_status.level.lost)
		g_status.level.plane.flying = GL_TRUE;
}

/**
 * Schaltet die Pause um.
 * Waehrend der Pause wird das Hilfefenster eingeblendet.
 */
void togglePause(void)
{
	g_status.paused = !g_status.paused;
}

/**
 * Schaltet die Hilfe um. (Hilfefenster wird eingeblendet)
 */
void toggleHelp (void)
{
	g_status.help = !g_status.help;
}

/**
 * Schaltet das Zeichnen der Normalen um.
 */
void toggleNormals (void)
{
	g_status.normals = !g_status.normals;
}

/**
 * Schaltet das Zeichnen der konvexen Huelle um.
 */
void toggleConvex (void)
{
	g_status.level.spline.convex = !g_status.level.spline.convex;
	if(g_status.level.spline.convex)
		calculateConvexHull(&g_status.level.spline);
	else
		free(g_status.level.spline.hullIndices);
}

/**
 * Schaltet den Interpolationstyp fuer die Kurve zwischen Spline und
 * Bezier um.
 */
void toggleType (void)
{
	g_status.level.spline.type = !g_status.level.spline.type;
	/* neue vertizes berechnen. */
	calculateFunctions(&g_status.level.spline);
	calculateVertices(&g_status.level.spline);
	calculateNormals(&g_status.level.spline);
	repositionPlane();
}

/**
 * Erhoeht die Detailstufe der zu zeichnenden Splinekurve.
 */
void increaseSplineDetail(void)
{
	/* Detailstufe erhoehen */
	if (g_status.level.spline.detail < SPLINE_MAX_DETAIL)
		++g_status.level.spline.detail;
	free(g_status.level.spline.vertices);
	free(g_status.level.spline.splineIndices);
	free(g_status.level.spline.normalIndices);
	allocateVertices(&g_status.level.spline);
	calculateVertices(&g_status.level.spline);
	allocateIndices(&g_status.level.spline);
	calculateNormals(&g_status.level.spline);
	allocateNormalIndices(&g_status.level.spline);
}

/**
 * Senkt die Detailstufe der zu zeichnenden Splinekurve.
 */
void decreaseSplineDetail(void)
{
	if (g_status.level.spline.detail != 0)
		--g_status.level.spline.detail;
	free(g_status.level.spline.vertices);
	free(g_status.level.spline.splineIndices);
	free(g_status.level.spline.normalIndices);
	allocateVertices(&g_status.level.spline);
	calculateVertices(&g_status.level.spline);
	allocateIndices(&g_status.level.spline);
	calculateNormals(&g_status.level.spline);
	allocateNormalIndices(&g_status.level.spline);
}

/* --- Funktionen durch Logiktick. --- */

/**
 * Berechnet die Spline beim Verschieben von Punkten neu.
 * Spline, Normalen und ggf. Konvexe Huelle werden neu berechnet,
 * das Flugzeug wird neu positioniert.
 */
void reticulateSplines (void)
{
	calculateFunctions(&g_status.level.spline);
	calculateVertices(&g_status.level.spline);
	calculateNormals(&g_status.level.spline);
	if (g_status.level.spline.convex) {
		free(g_status.level.spline.hullIndices);
		calculateConvexHull(&g_status.level.spline);
	}
	repositionPlane();
}

/**
 * Prueft, ob das Spiel gewonnen wurde.
 *
 * Das Spiel ist gewonnen, wenn alle Sterne eingesammelt wurden
 * Das Spiel ist verloren, wenn mit einer Wolke kollidiert wurde
 * oder die Spline durchlaufen und noch Sterne uebrig sind.
 *
 * @return true, falls gewonnen.
 */
GLboolean checkStars(void)
{
	GLuint i;
	GLboolean res = GL_TRUE;

	for (i = 1; i < g_status.level.entityCount && res; ++i) {
		res = (g_status.level.entities[i].type != entStar);
	}

	return res;
}

/**
 * Laesst das Flugzeug ueber eine bestimmte
 * Zeit entlang der Spline fortbewegen.
 *
 * @param interval Laenge der Flugbewegung in ms
 */
void doPlaneFlight (double interval)
{
	g_status.level.plane.t += interval * PLANE_T_PER_SEC;
	/* Flugzeug erreicht Ende eines Kurvenstuecks */
	if (g_status.level.plane.t >= 1) {
		/* Falls weiteren Kurvenstuecke: Aufs naechste wechseln. */
		if (g_status.level.plane.qIndex < g_status.level.spline.baseCount-4) {
			g_status.level.plane.t -= 1;
			g_status.level.plane.qIndex += 1;
		/* Ansonsten: Gewinn checken! */
		} else {
			g_status.level.plane.flying = GL_FALSE;
			g_status.level.plane.t = 1;
			g_status.level.won = checkStars();
			g_status.level.lost = !g_status.level.won;
		}
	}
	repositionPlane();
}

/**
 * Fuehrt Kollisionsueberpruefung des Flugzeugs mit
 * allen anderen Objekten durch.
 */
void checkPlaneCollisions(void)
{
	GLuint i;
	for (i=1;i<g_status.level.entityCount;++i) {
		if (checkColCircleCircle(g_status.level.entities[0].center,
		                         g_status.level.entities[i].center,
		                         g_status.level.entities[0].radius,
		                         g_status.level.entities[i].radius)) {
			switch(g_status.level.entities[i].type) {
				case entStar:
					/* Stern entfernen */
					g_status.level.entities[i].type = entNull;
					break;
				case entCloud:
					/* Verloren, Flugzeug stoppen */
					g_status.level.lost = GL_TRUE;
					g_status.level.plane.flying = GL_FALSE;
					break;
				default:
					break;
			}
		}
	}
}

/**
 * Fuehrt einen Logiktick durch.
 *
 * @param interval laenge des "ticks" in ms.
 */
void doLogic (double interval)
{
	if (g_status.level.plane.flying) {
		doPlaneFlight (interval);
		checkPlaneCollisions();
	}
}

/* --- Initialisierungsfunktionen --- */

/**
 * Initialisiert ein Flugzeug
 *
 * @param l Leveldatentyp
 */
void initPlane (Level * l)
{
	/* Entitydaten. */
	l->entities[0].type = entPlane;
	l->entities[0].center[cX] = 0.0f;
	l->entities[0].center[cY] = 0.0f;
	l->entities[0].radius = PLANE_RADIUS;
	l->entities[0].arc = 0.0f;
	/* Zusaetzliche Daten fuer den Flug. */
	l->plane.flying = GL_FALSE;
	l->plane.qIndex = 0;
	l->plane.t = 0;
	repositionPlane();
}

/**
 * Initialisiert ein Level.
 * (Entities... Flugzeug, Sterne, Wolken,... )
 *
 * @param l Leveldatentyp
 * @param level Levelnummer
 */
void initLevel (Level * l, GLuint level)
{
	GLuint i;
	l->number = level;
	l->won = GL_FALSE;
	l->lost = GL_FALSE;
	l->entityCount = (level == 0) ? 2 : 4;
	l->entities = (Entity *)malloc(sizeof(Entity) * l->entityCount);

	/* Entity 0, Flugzeug initialisieren */
	initPlane (l);

	/* Winkel alle auf 0. */
	for (i = 1; i < l->entityCount; ++i)
		l->entities[i].arc = 0.0f;

	switch (level) {
		case 0:
			/* Erstes Level: Ein Stern. */
			l->entities[1].type = entStar;
			l->entities[1].center[cX] = 0.0f;
			l->entities[1].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[1].radius = STAR_RADIUS;
			break;
		case 1:
			/* Zweites Level: Drei Sterne. */
			l->entities[1].type = entStar;
			l->entities[1].center[cX] = -.5f;
			l->entities[1].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[1].radius = STAR_RADIUS;

			l->entities[2].type = entStar;
			l->entities[2].center[cX] = 0.0f;
			l->entities[2].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[2].radius = STAR_RADIUS;

			l->entities[3].type = entStar;
			l->entities[3].center[cX] = +.5f;
			l->entities[3].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[3].radius = STAR_RADIUS;
			break;
		case 2:
			/* Drittes Level: Zwei Sterne, eine Wolke. */
			l->entities[1].type = entStar;
			l->entities[1].center[cX] = -.5f;
			l->entities[1].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[1].radius = STAR_RADIUS;

			l->entities[2].type = entCloud;
			l->entities[2].center[cX] = 0.0f;
			l->entities[2].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[2].radius = CLOUD_RADIUS;

			l->entities[3].type = entStar;
			l->entities[3].center[cX] = +.5f;
			l->entities[3].center[cY] = ran(STUFF_MIN_Y,STUFF_MAX_Y);
			l->entities[3].radius = STAR_RADIUS;
			break;
	}
}

/**
 * Bereinigt die Leveldaten
 * (Speicherplatz fuer Entities freigeben)
 *
 * @param l level dessen Entities freigegeben werden sollen
 */
void cleanupLevel (Level * l)
{
	free(l->entities);
}

/**
 * Initialisiert die Logikeinheit des Programms inklusive Kameradaten.
 */
void initLogic (void)
{
	/* Zufall init */
	srand(time(0));
	/* Allgemeine init */
	g_status.paused = GL_FALSE;
	g_status.help = GL_FALSE;
	g_status.normals = GL_FALSE;
	g_status.picked = 0;
	/* Spline init */
	initSpline(&g_status.level.spline);
	/* Spline fuer das Level vorbereiten. */
	initLevelSpline (&g_status.level.spline, START_LEVEL);
	/* Initialisierung von Leveldaten. */
	initLevel(&g_status.level, START_LEVEL);
}

/**
 * Raeumt die Logik auf.
 * Reservierter Speicher wird wieder freigegeben, etc.
 */
void cleanupLogic (void)
{
	cleanupLevel(&g_status.level);
	cleanupLevelSpline(&g_status.level.spline);
}

/**
 * Wechselt beim druecken von Space zum naechsten Level
 * bzw startet das fehlgeschlagene Level neu.
 */
void progressRestartLevel(void)
{
	Level * l = &g_status.level;
	GLuint level = l->number;

	if (l->won && level < MAX_LEVEL) {
		/* Gewonnen: zum naechsten Level, wenn moeglich. */
		cleanupLogic();
		initLevelSpline(&l->spline,level+1);
		initLevel(l,level+1);
	} else if (g_status.level.lost) {
		/* Verloren: Level resetten. */
		cleanupLogic();
		initLevelSpline(&l->spline,level);
		initLevel(l,level);
	}
}

/* --- Getter --- */

/**
 * Liefert die aktuellen globalen Szenenstatusdaten.
 *
 * @return das globale Szenendatenstruct.
 */
GameStatus * getStatus (void)
{
	return &g_status;
}

/**
 * Liefert die aktuellen Leveldaten.
 *
 * @return das Leveldatenstruct
 */
Level * getLevel (void)
{
	return &g_status.level;
}

/**
 * Liefert die aktuellen Splinedaten.
 *
 * @return das Splinedatenstruct
 */
Spline * getSpline (void)
{
	return &g_status.level.spline;
}
