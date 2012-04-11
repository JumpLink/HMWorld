/* Copyright (C) 2012  Pascal Garber
 * Copyright (C) 2012  Ole Lorenzen
 * Copyright (C) 2012  Patrick König
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 *	Ole Lorenzen <ole.lorenzen@gmx.net>
 *	Patrick König <knuffi@gmail.com>
 */

using GL;
using GLU;
using GLUT;
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer Ein-/Ausgabe-Verarbeitung.
	 */
	class OpenGLKeyboard {
		public static uchar UP='w';
		public static uchar RIGHT='d';
		public static uchar DOWN='s';
		public static uchar LEFT='a';
		public static uchar ACTION = 'f';
		public static uchar USE = 'e';
		public static uchar SWAP = 'r';
		/**
		 * Konstruktor.
		 */
		public OpenGLKeyboard() {
			init();
		}
		public void init() {
			/* Tastenwiederholungen ignorieren */
			glutIgnoreKeyRepeat(1);
			registerCallbacks();
		}
		/**
		 * Verarbeitung eines Tasturereignisses.
		 * q,ESC: Beenden
		 *
		 * @param key Taste, die das Ereignis ausgeloest hat. (ASCII-Wert oder WERT des
		 *        GLUT_KEY_<SPECIAL>.
		 * @param status Status der Taste, false=gedrueckt, true=losgelassen.
		 * @param isSpecialKey ist die Taste eine Spezialtaste?
		 * @param x x-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
		 * @param y y-Position des Mauszeigers zum Zeitpunkt der Ereignisausloesung.
		 */
		public static void handleKeyboardEvent (int key, bool status, bool isSpecialKey, int x, int y)
		requires (WORLD.PLAYERS != null)
		requires (WORLD.PLAYERS.size >= 1)
		{
			Player p = WORLD.PLAYERS.first ();
			/* Taste gedrueckt */
			if (status == false) {
				/* nicht-Spezialtasten */
				if (!isSpecialKey) {
					if (WORLD.STATE.dialog) {
						if (key == UP || key == DOWN)
							p.chooseAnswer (key == DOWN);
					} else {
						if (key == UP)
							p.setMotion (Direction.NORTH, true);
						if (key == LEFT)
							p.setMotion (Direction.WEST, true);
						if (key == DOWN)
							p.setMotion (Direction.SOUTH, true);
						if (key == RIGHT)
							p.setMotion (Direction.EAST, true);
					}
					if (key == ACTION)
						p.interact();
					if (key == USE)
						p.use ();
					if (key == SWAP)
						p.swap ();
					switch (key) {
						/* Programm beenden */
						case ESC:
							//cleanupLogic();
							GLib.Process.exit(0);
						case 'p': /*Paused-Mode On/Off*/
						case 'P':
							WORLD.STATE.toggle_paused();
							print(@"Pause: $(WORLD.STATE.paused)");
							break;
						case 'b': /*Debug-Mode On/Off*/
						case 'B':
							WORLD.STATE.toggle_debug();
							print(@"Debug: $(WORLD.STATE.debug)");
							break;
						case 'v': /*Debug-Mode On/Off*/
						case 'V':
							WORLD.STATE.toggle_perspective();
							break;
					}
				}
			} else {
				if (!isSpecialKey) {
					if (key == UP) {
						if (p.direction == Direction.NORTH)
							p.setMotion (Direction.NORTH, false);
					}
					if (key == LEFT) {
						if (p.direction == Direction.WEST)
							p.setMotion (Direction.WEST, false);
					}
					if (key == DOWN) {
						if (p.direction == Direction.SOUTH)
							p.setMotion (Direction.SOUTH, false);
					}
					if (key == RIGHT) {
						if (p.direction == Direction.EAST)
							p.setMotion (Direction.EAST, false);
					}
				}
			}
		}

		/**
		 * Callback fuer Tastendruck.
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		public static void cbKeyboard ( uchar key, int x, int y)
		{
			handleKeyboardEvent (key, (bool) GLUT_DOWN, false, x, y);
		}
		/**
		 * Callback fuer Taste loslassen
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf sobald die Taste losgelassen wurde.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		public static void cbUpKeyboard ( uchar key, int x, int y)
		{
			handleKeyboardEvent (key, (bool) GLUT_UP, false, x, y);
		}
		/**
		 * Callback fuer Druck auf Spezialtasten.
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		public static void cbSpecial (int key, int x, int y)
		{
			handleKeyboardEvent (key, (bool) GLUT_DOWN, true, x, y);
		}

		/**
		 * Registrierung der GLUT-Callback-Routinen.
		 */
		public static void registerCallbacks ()
		{
			/* Tasten-Druck-Callback - wird ausgefuehrt, wenn eine Taste gedrueckt wird */
			glutKeyboardFunc (cbKeyboard);
			/* Tasten-Druck-Callback - wird ausgefuehrt, wenn eine Taste losgelassen wird */
			glutKeyboardUpFunc (cbUpKeyboard);

			/* Spezialtasten-Druck-Callback - wird ausgefuehrt, wenn Spezialtaste
			 * (F1 - F12, Links, Rechts, Oben, Unten, Bild-Auf, Bild-Ab, Pos1, Ende oder
			 * Einfuegen) gedrueckt wird */
			glutSpecialFunc (cbSpecial);

			/* Mouse-Button-Callback (wird ausgefuehrt, wenn eine Maustaste
			 * gedrueckt oder losgelassen wird) */
			//glutMouseFunc (cbMouseButton);

			/* Mausbewegungs-Callback bei gedrueckter Taste */
			//glutMotionFunc (cbMouseMotion);
		}
	}
}