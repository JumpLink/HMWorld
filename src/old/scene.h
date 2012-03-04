#ifndef __SCENE_H__
#define __SCENE_H__
/**
 * @file
 * Schnittstelle des Darstellungs-Moduls.
 * Das Modul kapselt die Rendering-Funktionalitaet (insbesondere der OpenGL-
 * Aufrufe) des Programms.
 *
 * Uebung 02: Splinekuvenspiel
 *
 * @author minf8908, minf7481
 */

/**
 * Zeichenfunktion.
 * Stellt die komplette Szene dar.
 */
void drawScene (void);

/**
 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
 * Setzt Hintergrund- und Zeichenfarbe, aktiviert Tiefentest und
 * Backface-Culling.
 * @return Rueckgabewert: im Fehlerfall 0, sonst 1.
 */
int initScene (void);

/**
 * (De-)aktiviert den Wireframe-Modus.
 */
void toggleWireframeMode (void);

#endif
