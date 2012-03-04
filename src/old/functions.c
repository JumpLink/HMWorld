/**
 * @file
 * Modul mit Hilfsfunktionen.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

#include "functions.h"

/**
 * Liefert das Ergebnis einer Funktion q zum
 * Punkt t [0..1]
 *
 * @param q Funktion
 * @param t Punkt an dem der Interpolationswert gesucht wird [0..1]
 */
GLdouble functionAt(Vector4d q, GLdouble t)
{
	return q[0] * t * t * t +
	       q[1] * t * t +
	       q[2] * t +
	       q[3];
}

/**
 * Multipliziert eine Matrix m mit einem Vektor v
 *
 * @param m Matrix
 * @param v Vektor
 * @param res Ergebnisvektor x = m * v
 */
void multMatrixVector(Matrix4d m, Vector4d v, Vector4d res)
{
	GLuint i;

	for(i = 0; i < 4; ++i)
		res[i] = m[i][0] * v[0] + m[i][1] * v[1] + m[i][2] * v[2] + m[i][3] * v[3];
}

/**
 * Multipliziert ein Skalar s mit einem Vektor v
 *
 * @param s Skalar
 * @param v Vektor
 * @param res Ergebnisvektor s * v
 */
void multScalarVector(GLdouble s, Vector4d v, Vector4d res)
{
	GLuint i;

	for(i = 0; i < 4; ++i)
		res[i] = s * v[i];
}

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
GLboolean checkColCircleCircle (Vector2d c1, Vector2d c2, GLdouble r1, GLdouble r2)
{
	return sqr(c1[cX]-c2[cX]) + sqr(c1[cY]-c2[cY]) <= sqr(r1 + r2);
}
