/**
 * @file
 * Splinekurvenmodul.
 * Das Modul kapselt Logik fuer Splinekurven.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#ifdef MACOSX
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

/* ---- Eigene Header einbinden ---- */
#include "spline.h"
#include "consts.h"
#include "functions.h"

/* ---- Konstanten ---- */

/** Interpolationsmatrix fuer B-Spline Splines. */
static Matrix4d splineMatrix = { { -1,  3, -3,  1 },
                                 {  3, -6,  3,  0 },
                                 { -3,  0,  3,  0 },
                                 {  1,  4,  1,  0 } };
/** Interpolationsmatrix fuer Bezier. */
static Matrix4d bezierMatrix = { { -1,  3, -3,  1 },
                                 {  3, -6,  3,  0 },
                                 { -3,  3,  0,  0 },
                                 {  1,  0,  0,  0 } };

/* ---- Funktionen ---- */

/**
 * Liefert die Vertexanzahl der Spline in Abhaengigkeit der
 * Detailstufe und der Stuetzpunktanzahl.
 *
 * @param s Spline fuer das berechnet werden soll.
 */
GLuint getSplineVertexCount (Spline * s)
{
	return (s->baseCount-2 + s->detail*(s->baseCount-3));
}

/**
 * Alloziiert die Funktionen qx und qy
 *
 * @param s Spline
 */
void allocateFunctions (Spline * s)
{
	s->qx = (Vector4d*) malloc(sizeof(Vector4d) * (s->baseCount-3));
	s->qy = (Vector4d*) malloc(sizeof(Vector4d) * (s->baseCount-3));
}

/**
 * Berechnet die Funktionen qx und qy fuer alle Splinestuecke.
 * Hierbei wird jeweils die Bezier- bzw B-Spline-Matrix mit den
 * Geometriedaten fuer das jeweilige Teilstueck Multipliziert.
 *
 * @param s Spline
 */
void calculateFunctions(Spline * s)
{
	GLuint i,j;
	/* Iterieren ueber die Splinekurvenstuecke */
	for(i = 0; i < s->baseCount-3; ++i) {
		/* Geometrievektoren in x und y */
		Vector4d gx, gy;
		for(j = 0; j < 4; ++j) {
			gx[j] = s->basePoints[i+j][cX];
			gy[j] = s->basePoints[i+j][cY];
		}

		/* Resultierende Funktionen qx und qy, Spline. */
		if (s->type == intSpline) {
			multMatrixVector(splineMatrix, gx, s->qx[i]);
			multMatrixVector(splineMatrix, gy, s->qy[i]);
			multScalarVector((double)1/6, s->qx[i], s->qx[i]);
			multScalarVector((double)1/6, s->qy[i], s->qy[i]);
		/* Bezier. */
		} else {
			multMatrixVector(bezierMatrix, gx, s->qx[i]);
			multMatrixVector(bezierMatrix, gy, s->qy[i]);
		}
	}
}

/**
 * Alloziiert das Vertexarray.
 * Beinhaelt die Splinevertizes und die der Normalen
 *
 * @param s Spline
 */
void allocateVertices (Spline * s)
{
	/* Vertexanzahl (2 weniger fuer die wegfallenden Normalen vorne und hinten. */
	s->vertexCount = 2 * getSplineVertexCount(s) - 2;
	s->vertices = (Vertex*) malloc(sizeof(Vertex) * s->vertexCount);

	glVertexPointer(2, GL_DOUBLE, sizeof(Vertex), &(s->vertices[0][cX]));
}

/**
 * Berechnet die Vertizes fuer eine Splinekurve mit
 * Hilfe der vorgegebenen Funktionen qx und qy.
 *
 * @param s Splinekurve
 */
void calculateVertices (Spline * s)
{
	GLuint i,j;
	/* Durch die Splinestuecke laufen */
	for(i = 0; i < s->baseCount-3; ++i) {
		/* Durch die Detailstufe laufen */
		for(j = 0; j < s->detail+1 ; ++j) {
			s->vertices[i*(s->detail+1)+j][cX] = functionAt(s->qx[i], (double)j/(s->detail+1));
			s->vertices[i*(s->detail+1)+j][cY] = functionAt(s->qy[i], (double)j/(s->detail+1));
		}
	}
	/* Letzter Vertex der Spline */
	s->vertices[getSplineVertexCount(s)-1][cX] = functionAt(s->qx[s->baseCount-4], 1);
	s->vertices[getSplineVertexCount(s)-1][cY] = functionAt(s->qy[s->baseCount-4], 1);
}

/**
 * Berechnet eine Normale.
 * Normalen werden gebildet durch das Kreuzprodukt vom
 * Verbindungsvektor der beiden Nachbarvektoren eines Vertex
 * und der z-Achse (0,0,1).
 *
 * @param v1 Vorgaenger des Vertex
 * @param v2 Der Vertex selbst
 * @param v3 Nachfolger des Vertex
 */
void calcNormal (Vertex v1, Vertex v2, Vertex v3, Vertex * res)
{
	GLdouble len;
	/* Verbindungsvektor bilden und Kreuzprodukt. */
	(*res)[cX] =   v1[cY] - v3[cY];
	(*res)[cY] = -(v1[cX] - v3[cX]);
	/* Normalisieren */
	len = sqrt(sqr((*res)[cX])+sqr((*res)[cY]));
	(*res)[cX] /= len;
	(*res)[cY] /= len;
	/* Auf Einheitliche Laenge bringen */
	(*res)[cX] *= NORMAL_LENGTH;
	(*res)[cY] *= NORMAL_LENGTH;
	/* Ausgangsvektor draufaddieren */
	(*res)[cX] += v2[cX];
	(*res)[cY] += v2[cY];
}

/**
 * Berechnet die Normalen der Splinekurve.
 *
 * @param s Spline
 */
void calculateNormals (Spline * s)
{
	GLuint i;
	GLuint offset = getSplineVertexCount(s);

	/* Kreuprodukt Verbindungsvektor der Nachbarn */
	for (i = 1; i < getSplineVertexCount(s)-1; ++i) {
		calcNormal(s->vertices[i-1], s->vertices[i], s->vertices[i+1], &(s->vertices[offset+i-1]));
	}
}

/**
 * Alloziiert und initialisiert das Indexarray zum
 * zeichnen der Splinekurve.
 *
 * @param s Spline
 */
void allocateIndices (Spline * s)
{
	GLuint i;
	s->splineIndexCount = getSplineVertexCount(s);
	s->splineIndices = (GLuint *) malloc(sizeof(GLuint) * s->splineIndexCount);
	for (i = 0; i < s->splineIndexCount; ++i) {
		s->splineIndices[i] = i;
	}
}

/**
 * Alloziiert und initialisiert das Indexarray zum
 * zeichnen der Normalen.
 *
 * @param s Spline
 */
void allocateNormalIndices (Spline * s)
{
	GLuint i = 0;

	s->normalIndexCount = (getSplineVertexCount(s)-2) * 2;
	s->normalIndices = (GLuint *) malloc(sizeof(GLuint) * s->normalIndexCount);

	while (i < s->normalIndexCount) {
		s->normalIndices[i] = i/2 + 1;
		s->normalIndices[i+1] = i/2 + getSplineVertexCount(s);
		i += 2;
	}
}

/**
 * Berechnet die konvexe Huelle. Nicht.
 * Obsolet, da unfunktionierend.
 *
 * @param s Spline.
 */
void calculateConvexHull2 (Spline * s)
{
	GLuint i,last;
	GLuint cur;
	GLboolean found = GL_FALSE;
	GLboolean finished = GL_FALSE;
	GLint * calced = (GLint*) malloc(sizeof(GLint) * s->baseCount);
	GLboolean * uncalced = (GLboolean*) malloc(sizeof(GLboolean) * s->baseCount);
	GLdouble * arcs = (GLdouble*) malloc(sizeof(GLdouble) * s->baseCount);

	/* Alle Punkte in unberechnet, keiner in berechnet */
	for (i = 0; i < s->baseCount; ++i) {
		calced[i] = -1;
		uncalced[i] = GL_TRUE;
	}

	/* Schiebe Punkt mit niedrigstem Y-Wert nach berechnet.
	 * Bei mehreren mit niedrigstem Y, nehme niedrigstes X */
	calced[0] = 0;
	for (i = 1; i < s->baseCount; ++i) {
		if (s->basePoints[i][cY] < s->basePoints[calced[0]][cY] ||
			(s->basePoints[i][cY] == s->basePoints[calced[0]][cY] &&
			 s->basePoints[i][cX] < s->basePoints[calced[0]][cX]))
			calced[0] = i;
	}

	uncalced[calced[0]] = GL_FALSE;
	last = 0;

	/* Iteration */
	while (!finished) {
		/* bestimme fuer alle Punkte aus "unberechnet" und fuer den Startpunkt
		 * den Winkel zwischen der Verbindung vom zuletzt bestimmten Punkt
		 * zum zu untersuchenden Punkt und der x-Achse */
		for (i = 0; i < s->baseCount; ++i) {
			if (uncalced[i] || i == (GLuint)calced[0]) {
				Vector2d con;
				GLdouble len;
				/* "Verbindungsvektor" bilden und normieren */
				con[cX] = s->basePoints[i][cX] - s->basePoints[calced[last]][cX];
				con[cY] = s->basePoints[i][cY] - s->basePoints[calced[last]][cY];
				len = sqrt(sqr(con[cX]) + sqr(con[cY]));
				if (len != 0) {
					con[cX] /= len; con[cY] /= len;
				}
				/* Winkel -> Punktprodukt mit der x-Achse */
				arcs[i] = acos(con[cX]);
				/* wenn der y-Wert des neuen Punktes kleiner als der
				 * y-Wert des zuletzt in "berechnet" eingefuegten Punktes
				 * ist, veraendere den Winkel zu 360 Grad - Winkel. */
				if (s->basePoints[i][cY] < s->basePoints[calced[last]][cY])
					arcs[i] = 2 * PI - arcs[i];
			}
		}

		/* fuege den Punkt mit dem kleinsten Winkel, der groesser als der
		 * Winkel beim letzten bestimmten Punkt ist, als naechsten in
		 * "berechnet" ein und entferne ihn aus "unberechnet" */
		found = GL_FALSE;
		for (i = 0; i < s->baseCount; ++i) {
			if (uncalced[i] || i == (GLuint)calced[0]) {
				/* Wir haben noch nix gefunden und der Winkel ist groesser oder
				 * wir kennen schon was und der Winkel ist groesser aber kleiner als bisher */
				if ((!found && arcs[i] > arcs[calced[last]]) ||
				    (found && arcs[i] > arcs[calced[last]] && arcs[i] < arcs[cur])) {
					cur = i;
					found = GL_TRUE;
				}
			}
		}

		/* wiederhole dies, bis der Punkt mit dem kleinsten Winkel der
		 * Startpunkt ist. */
		finished = (cur == (GLuint)calced[0] || !found);

		if (!finished) {
			uncalced[cur] = GL_FALSE;
			++last;
			calced[last] = cur;
		}
	}

	s->hullIndexCount = last+1;

	s->hullIndices = (GLuint *) malloc(sizeof(GLuint)*s->hullIndexCount);

	for(i = 0; i < s->hullIndexCount; ++i)
		s->hullIndices[i] = calced[i];

	free(calced);
	free(uncalced);
	free(arcs);
}

/**
 * Vertauscht die Inhalte zweier Vektoren miteinander.
 *
 * @param p0 erster Vektor
 * @param p1 zweiter Vektor
 */
void exchange(Vector2d p0, Vector2d p1)
{
	Vector2d t;
	t[cX] = p0[cX];
	t[cY] = p0[cY];
	p0[cX] = p1[cX];
	p0[cY] = p1[cY];
	p1[cX] = t[cX];
	p1[cY] = t[cY];
}

/**
 * Bestimmt den Winkel des Verbindungsvektors p-r der Punkte zur
 * x-Achse. (Kurz gesagt: Bestimmt den Winkel, in dem p zu r steht.)
 *
 * @param p zu testender Punkt
 * @param r Referenzpunkt
 *
 * @return Winkel zwischen 0 und 2*PI, in dem p zu r steht.
 */
double rel(Vector2d p, Vector2d r)
{
	Vector2d c;
	GLdouble l;
	c[cX] = p[cX] - r[cX];
	c[cY] = p[cY] - r[cY];
	l = sqrt(sqr(c[cX]) + sqr(c[cY]));
	if (l == 0) l = 1;
	return p[cY] < r[cY] ? 2 * PI - acos(c[cX]/l) : acos(c[cX]/l);
}

/**
 * Bubblesort.
 * Sortiert das uebergebene Punktarray nach dem Winkel der Punkte
 * zu Punkt 0 im Array.
 *
 * @param p Punktarray
 * @param n Anzahl der Punkte
 */
void bubbleSort(Vector2d * p, GLuint n)
{
	GLboolean vertauscht;
	GLuint i;
	do {
		vertauscht = GL_FALSE;
		for (i = 2; i < n; ++i) {
			if (rel(p[i-1],p[0]) > rel(p[i],p[0])) {
				exchange(p[i-1],p[i]);
				vertauscht = GL_TRUE;
			}
		}
    	n--;
	} while (vertauscht && n > 1);
}

/**
 * ccw: ist
 * < 0 wenn P2 rechts von P0->P1
 * = 0 wenn P2 auf P0->P1
 * > 0 wenn P2 links von P0->P1
 *
 * @param p0 Startpunkt
 * @param p1 Endpunkt
 * @param p2 Punkt der verglichen werden soll
 */
double ccw(Vector2d p0, Vector2d p1, Vector2d p2)
{
    return (p1[cX] - p0[cX])*(p2[cY] - p0[cY]) - (p2[cX] - p0[cX])*(p1[cY] - p0[cY]);
}

/**
 * Graham Scan-Algorithmus zur Bestimmung der
 * Huellkurve
 *
 * @param p Punkte deren Huelle bestimmt werden soll. Auch: Ziel fuer die Huellpunkte.
 * @param n Anzahl der Punkte
 *
 * @return Anzahl der Punkte in der Huellkurve
 */
int grahamScan(Vector2d * p, int n)
{
	int i, min, m;
	/* Anfangspunkt bestimmen */
	for (min = 0, i = 1; i < n; i++)
		if (p[i][cY] < p[min][cY])
			min = i;
	for (i = 0; i < n; i++)
		if (p[i][cY] == p[min][cY] && p[i][cX] < p[min][cX])
			min = i;

	/* Tausche Minimalpunkt nach Vorne */
	exchange(p[0],p[min]);

	/* Sortiere nach winkel */
	bubbleSort(p,n);

	/* Graham-Scan. */
	i = 3; m = 3;
	while (m < n) {
		exchange(p[i],p[m]);
		while (ccw(p[i-1],p[i-2],p[i]) >= 0) {
			exchange(p[i-1],p[i]);
			--i;
		}
		m++;
		i++;
	}

	return i;
}

/**
 * Berechnet die konvexe Huelle mittels Graham Scan Algorithmus.
 *
 * @param s Spline, deren Huelle berechnet werden soll.
 */
void calculateConvexHull(Spline * s)
{
	GLuint i,j;

	/* Kopie des Basispunktearrays anlegen */
	Vector2d * test = (Vector2d*) malloc(sizeof(Vector2d)*s->baseCount);
	for(i = 0; i < s->baseCount; ++i) {
		test[i][cX] = s->basePoints[i][cX];
		test[i][cY] = s->basePoints[i][cY];
	}

	/* Huellkurve bestimmen mit Graham Scan */
	s->hullIndexCount = grahamScan(test, s->baseCount);

	/* fprintf(stderr,"DEBUG huelle:\n");
	for(i=0;i<s->hullIndexCount;++i)
		fprintf(stderr,"(%f:%f)\n",test[i][cX],test[i][cY]); */

	/* Punkteindizes finden und eintragen. */
	s->hullIndices = malloc(sizeof(Vector2d)*s->hullIndexCount);
	for (i = 0; i < s->hullIndexCount; ++i) {
		GLboolean done = GL_FALSE;
		for (j = 0; j < s->baseCount && !done; ++j) {
			if (fabs(test[i][cX] - s->basePoints[j][cX]) < EPSILON &&
			    fabs(test[i][cY] - s->basePoints[j][cY]) < EPSILON)
			{
				s->hullIndices[i] = j; done = GL_TRUE;
			}
		}
	}

	/* Speicher fuer das temporaere Punktearray loeschen */
	free(test);
}

/**
 * Loescht den gesamten von der Spline
 * alloziierten Speicher
 *
 * @param s Spline
 */
void cleanupLevelSpline (Spline * s)
{
	free(s->basePoints);
	free(s->qx);
	free(s->qy);
	free(s->vertices);
	free(s->splineIndices);
	free(s->normalIndices);
	if(s->convex)
		free(s->hullIndices);
}

/**
 * Initialisiert die Stuetzpunkte fuer ein Level.
 * Level 0 hat 4 Stuetzpunkte, Level 1 hat 5, Level 2 hat 6.
 * Die Stuetzpunkte werden aequidistant verteilt.
 *
 * @param s Spline
 * @param level Level fuer das initialisiert werden soll
 */
void initBasePoints (Spline * s, GLuint level)
{
	GLuint i;
	s->baseCount = level + 4;
	s->basePoints = malloc(sizeof(Vector2d)*s->baseCount);
	for(i = 0; i < s->baseCount; ++i) {
		s->basePoints[i][cX] = (double)i/(s->baseCount-1)*2-1;
		s->basePoints[i][cY] = 0.0f;
	}
}

/**
 * Initialisiert die komplette Spline fuer ein Level
 *
 * @param s Spline
 * @param level Level fuer das initialisiert werden soll
 */
void initLevelSpline (Spline * s, GLuint level)
{
	/* Stuetzpunkte erzeugen */
	initBasePoints(s, level);
	/* Funktionen qx, qy allozieren und berechnen. */
	allocateFunctions(s);
	calculateFunctions(s);
	/* Vertizes alloziieren und Splinevertizes berechnen */
	allocateVertices(s);
	calculateVertices(s);
	/* Indizes der Splinekurve alloziieren und berechnen */
	allocateIndices(s);
	/* Normalen und dazugehoerige Indizes berechnen */
	calculateNormals(s);
	allocateNormalIndices(s);
	if (s->convex)
		calculateConvexHull(s);
}

/**
 * Initialisiert die Splinegrunddaten am
 * Anfang des Programms
 *
 * @param s Spline
 */
void initSpline (Spline * s)
{
	s->detail = SPLINE_DETAIL;
	s->convex = GL_FALSE;
	s->type = intSpline;
}
