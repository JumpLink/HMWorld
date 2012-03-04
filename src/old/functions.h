#ifndef __FUNCTIONS_H__
#define __FUNCTIONS_H__
/**
 * @file
 * Schnittstelle des Moduls fuer Hilfsfunktionen.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */

/* ---- Eigene Header einbinden ---- */
#include "types.h"

/* ---- Macros ---- */

/** Quadrat einer Zahl */
#define sqr(x) ((x)*(x))

/** Zufall zwischen min und max */
#define ran(min,max) (((double)rand())/RAND_MAX*((max)-(min))+(min))

/** Bogenmass nach Gradmass */
#define rad2deg(x) ((x)/PI*180)

/** Gradmass nach Bogenmass */
#define deg2rad(x) ((x)/180*PI)

/* ---- Funktionen ---- */

/**
 * Liefert das Ergebnis einer Funktion q zum
 * Punkt t [0..1]
 *
 * @param q Funktion
 * @param t Punkt an dem der Interpolationswert gesucht wird [0..1]
 */
GLdouble functionAt(Vector4d q, GLdouble t);

/**
 * Multipliziert eine Matrix m mit einem Vektor v
 *
 * @param m Matrix
 * @param v Vektor
 * @param res Ergebnisvektor x = m * v
 */
void multMatrixVector(Matrix4d m, Vector4d v, Vector4d res);

/**
 * Multipliziert ein Skalar s mit einem Vektor v
 *
 * @param s Skalar
 * @param v Vektor
 * @param res Ergebnisvektor s * v
 */
void multScalarVector(GLdouble s, Vector4d v, Vector4d res);

/**
 * Prueft zwei Kreise auf Kollision.
 * Zwei Kreisobjekte Kollidieren, wenn der Abstand zwischen ihren
 * Mittelpunkten kleiner ist, als ihre Radien.
 *
 * @param c1 Mittelpunkt Objekt 1
 * @param c2 Mittelpunkt Objekt 2
 * @param r1 Radius Objekt 1
 * @param r2 Radius Objekt 2
 *
 * @return true, falls Kollision, ansonsten false.
 */
GLboolean checkColCircleCircle (Vector2d c1, Vector2d c2, GLdouble r1, GLdouble r2);

#endif
