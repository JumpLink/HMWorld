#ifndef __CONSTS_H__
#define __CONSTS_H__
/**
 * @file
 * Konstanten
 * Header mit wichtigen Konstanten zum Programm.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- Allgemeine Konstanten ---- */

/** Anzahl der Aufrufe der Timer-Funktion pro Sekunde */
#define TIMER_CALLS_PS 60
/** Kleine Zahl fuer Vergleich von Fliesskommazahlen */
#define EPSILON 0.000001f
/** Pi. */
#define PI 3.1415926535897932384626433832795029f

/** Zeichenlaenge der Normalen */
#define NORMAL_LENGTH 0.1f
/** Detailstufe fuer alle Kreisobjekte (3 fuer Dreiecke) */
#define CIRCLE_DETAIL 10

/* ---- Level ---- */
/** Maximales Level */
#define MAX_LEVEL 2
/** Startlevel */
#define START_LEVEL 0

/* ---- Flugzeug ---- */
/** Kollisionsradius des Flugzeugs */
#define PLANE_RADIUS 0.07f
/** Abstand des Fliegers von der Splinekurve */
#define PLANE_SPLINE_DISTANCE 0.15f
/** Wieviele "t" fliegt das Flugzeug pro Sekunde */
#define PLANE_T_PER_SEC 1.0f

/* ---- Sterne ---- */
/** Kollisionsradius der Sterne */
#define STAR_RADIUS 0.025f
/** Minimale Zufalls-y-Wert der Sterne */
#define STUFF_MIN_Y -.65f
/** Maximaler Zufalls-y-Wert der Sterne */
#define STUFF_MAX_Y +.75f

/* ---- Wolken ---- */
/** Kollisionsradius der Wolken */
#define CLOUD_RADIUS 0.1f

/* ---- Spline ---- */
/** Spline-Defaultdetailstufe */
#define SPLINE_DETAIL 10
/** Maximale Splinedetailstufe */
#define SPLINE_MAX_DETAIL 20
/** Radius der Stuetzpunkte */
#define SPLINE_BASE_RADIUS 0.025f

#endif /* __CONSTS_H__ */
