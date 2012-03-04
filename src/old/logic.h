#ifndef __LOGIC_H__
#define __LOGIC_H__
/**
 * @file
 * Schnittstelle des Logik-Moduls.
 * Das Modul kapselt die Programmlogik. Wesentliche Programmlogik ist die
 * Verwaltung des Rotationswinkels des Wuerfels. Die Programmlogik ist
 * weitgehend unabhaengig von Ein-/Ausgabe (io.h/c) und
 * Darstellung (scene.h/c).
 *
 * Uebung 01: Wuerfel mit Vertex-Arrays
 *
 * @author minf8908, minf7481
 */

/* ---- Eigene Header einbinden ---- */
#include "types.h"

/**
 * Startet den Flug des Fliegers.
 */
void startFlight(void);

/**
 * Schaltet die Pause um. (Timer wird gestoppt)
 */
void togglePause (void);

/**
 * Schaltet die Hilfe um. (Hilfefenster wird eingeblendet)
 */
void toggleHelp (void);

/**
 * Schaltet das Zeichnen der Normalen um.
 */
void toggleNormals (void);

/**
 * Schaltet das Zeichnen der konvexen Huelle um.
 */
void toggleConvex (void);

/**
 * Schaltet den Interpolationstyp fuer die Kurve zwischen Spline und
 * Bezier um.
 */
void toggleType (void);

/**
 * Erhoeht die Detailstufe der zu zeichnenden Splinekurve.
 */
void increaseSplineDetail(void);

/**
 * Senkt die Detailstufe der zu zeichnenden Splinekurve.
 */
void decreaseSplineDetail(void);

/**
 * Wechselt beim druecken von Space zum naechsten Level
 * bzw startet das fehlgeschlagene Level neu.
 */
void progressRestartLevel(void);

/**
 * Berechnet die Spline beim Verschieben von Punkten neu.
 */
void reticulateSplines (void);

/**
 * Berechnet die Konvexe Huelle beim Verschieben von Punkten neu.
 */
void reticulateConvexHull (void);

/**
 * Fuehrt einen Logiktick durch.
 *
 * @param interval laenge des "ticks" in ms.
 */
void doLogic (double interval);

/**
 * Initialisiert die Logikeinheit des Programms inklusive Kameradaten.
 */
void initLogic (void);

/**
 * Raeumt die Logik auf.
 * Reservierter Speicher wird wieder freigegeben, etc.
 */
void cleanupLogic(void);

/**
 * Liefert die aktuellen globalen Szenenstatusdaten.
 *
 * @return das globale Szenendatenstruct.
 */
GameStatus * getStatus (void);

/**
 * Liefert die aktuellen Leveldaten.
 *
 * @return das Leveldatenstruct
 */
Level * getLevel(void);

#endif
