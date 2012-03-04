#ifndef __SPLINE_H__
#define __SPLINE_H__
/**
 * @file
 * Schnittstelle des Splinekurven-Moduls.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */

/* ---- Eigene Header einbinden ---- */
#include "types.h"

/* ---- Funktionen ---- */

/**
 * Alloziiert das Vertexarray.
 * Beinhaelt die Splinevertizes und die der Normalen
 *
 * @param s Spline
 */
void allocateVertices (Spline * s);

/**
 * Alloziiert und initialisiert das Indexarray zum
 * zeichnen der Splinekurve.
 *
 * @param s Spline
 */
void allocateIndices (Spline * s);

/**
 * Alloziiert und initialisiert das Indexarray zum
 * zeichnen der Normalen.
 *
 * @param s Spline
 */
void allocateNormalIndices (Spline * s);

/**
 * Berechnet die Funktionen qx und qy fuer alle Splinestuecke.
 * Hierbei wird jeweils die Bezier- bzw B-Spline-Matrix mit den
 * Geometriedaten fuer das jeweilige Teilstueck Multipliziert.
 *
 * @param s Spline
 */
void calculateFunctions (Spline * s);

/**
 * Berechnet die Vertizes fuer eine Splinekurve mit
 * Hilfe der vorgegebenen Funktionen qx und qy.
 *
 * @param s Splinekurve
 */
void calculateVertices (Spline * s);

/**
 * Berechnet die Normalen der Splinekurve.
 *
 * @param s Spline
 */
void calculateNormals (Spline * s);

/**
 * Berechnet die Konvexe Huelle.
 *
 * @param s Spline.
 */
void calculateConvexHull (Spline * s);

/**
 * Loescht den gesamten von der Spline
 * alloziierten Speicher
 *
 * @param s Spline
 */
void cleanupLevelSpline (Spline * s);

/**
 * Initialisiert die komplette Spline fuer ein Level
 *
 * @param s Spline
 * @param level Level fuer das initialisiert werden soll
 */
void initLevelSpline (Spline * s, GLuint level);

/**
 * Initialisiert die Splinegrunddaten am
 * Anfang des Programms
 *
 * @param s Spline
 */
void initSpline (Spline * s);

#endif
