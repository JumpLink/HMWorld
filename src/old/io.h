#ifndef __IO_H__
#define __IO_H__
/**
 * @file
 * Schnittstelle des Ein-/Ausgabe-Moduls.
 * Das Modul kapselt die Ein- und Ausgabe-Funktionalitaet (insbesondere die GLUT-
 * Callbacks) des Programms.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/**
 * Initialisiert das Programm (inkl. I/O und OpenGL) und startet die
 * Ereignisbehandlung.
 *
 * @param title Beschriftung des Fensters
 * @param width Breite des Fensters
 * @param height Hoehe des Fensters
 */
int initAndStartIO (char *title, int width, int height);

#endif
