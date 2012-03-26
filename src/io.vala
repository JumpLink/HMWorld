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
/*using SDL;
using SDLImage;*/
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer Ein-/Ausgabe-Verarbeitung.
	 */
	class IO {

		/**
		 * Konstruktor.
		 */
		public IO() {

		}

		/**
		 * Setzen der Projektionsmatrix.
		 * Setzt die Projektionsmatrix fuer die Szene.
		 */
		static void setProjection ()
		{
			/* Nachfolgende Operationen beeinflussen Projektionsmatrix */
			glMatrixMode (GL_PROJECTION);
			/* Matrix zuruecksetzen - Einheitsmatrix laden */
			glLoadIdentity ();
			if (!WORLD.STATE.perspective) {
				glOrtho (	0, WORLD.STATE.window_width,						/* links, rechts */
						 	WORLD.STATE.window_height, 0,						/* unten, oben */
							-128, 128);											/* tiefe */
				/* verschiebt die Welt in die Mitte	 */
				glTranslatef((GL.GLfloat)WORLD.CURRENT_MAP.shift_x,(GL.GLfloat)WORLD.CURRENT_MAP.shift_y,0);
			} else {
				gluPerspective (100.0f, (float) WORLD.STATE.window_width/WORLD.STATE.window_height, -128, 128 );
				gluLookAt(WORLD.STATE.window_width/2, WORLD.STATE.window_height, -128, WORLD.STATE.window_width/2, 0, 128, 0,-1,0);
			}
		}
		/**
		 * Timer-Callback.
		 * Initiiert Berechnung der aktuellen Position und Farben und anschliessendes
		 * Neuzeichnen, setzt sich selbst erneut als Timer-Callback.
		 *
		 * @param lastCallTime Zeitpunkt, zu dem die Funktion als Timer-Funktion
		 *   registriert wurde (In).
		 */
		public static void cbTimer (int lastCallTime)
		{
			/* Seit dem Programmstart vergangene Zeit in Millisekunden */
			int thisCallTime = glutGet (GLUT_ELAPSED_TIME);
			/* Seit dem letzten Funktionsaufruf vergangene Zeit in Sekunden */
			WORLD.STATE.interval = (double) (thisCallTime - lastCallTime) / 1000.0f;

			/* neue Position berechnen (zeitgesteuert) */
			WORLD.timer ();

			/* Wieder als Timer-Funktion registrieren, falls nicht pausiert */
			if(!WORLD.STATE.paused)
				glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);

			/* Neuzeichnen anstossen */
			glutPostRedisplay ();
		}

		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		static void cbDisplay ()
		{

			/* Colorbuffer leeren */
			glClear (GL_COLOR_BUFFER_BIT);

			/* Nachfolgende Operationen beeinflussen Modelviewmatrix */
			glMatrixMode (GL_MODELVIEW);

			/* Welt zeichen */
			WORLD.draw();

			/* Szene anzeigen / Buffer tauschen */
			glutSwapBuffers ();
		}

		/**
		 * Callback fuer Aenderungen der Fenstergroesse.
		 * Initiiert Anpassung der Projektionsmatrix an veränderte Fenstergroesse.
		 * @param w Fensterbreite (In).
		 * @param h Fensterhoehe (In).
		 */
		public static void cbReshape (int w, int h)
		{
			/* Das ganze Fenster ist GL-Anzeigebereich */
			glViewport (0, 0, (GLsizei) w, (GLsizei) h);
			/* Gibt die aktuelle Fenstergroesse an WORLD.STATE.VIEWPORT zurueck*/
			glGetIntegerv( GL_VIEWPORT, WORLD.STATE.VIEWPORT );
			/* Anpassen der Projektionsmatrix an das Seitenverhältnis des Fensters */
			setProjection ();
			//print("- Fensterinhalt nach groesse angepasst -");
		}

		/**
		 * Callback fuer Tastendruck.
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		static void cbKeyboard ( uchar key, int x, int y)
		{
			WORLD.STATE.controler.handleKeyboardEvent (key, (bool) GLUT_DOWN, false, x, y);
		}
		/**
		 * Callback fuer Taste loslassen
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf sobald die Taste losgelassen wurde.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		static void cbUpKeyboard ( uchar key, int x, int y)
		{
			WORLD.STATE.controler.handleKeyboardEvent (key, (bool) GLUT_UP, false, x, y);
		}
		/**
		 * Callback fuer Druck auf Spezialtasten.
		 * Ruft Ereignisbehandlung fuer Tastaturereignis auf.
		 *
		 * @param key betroffene Taste (In).
		 * @param x x-Position der Maus zur Zeit des Tastendrucks (In).
		 * @param y y-Position der Maus zur Zeit des Tastendrucks (In).
		 */
		static void cbSpecial (int key, int x, int y)
		{
			WORLD.STATE.controler.handleKeyboardEvent (key, (bool) GLUT_DOWN, true, x, y);
		}

		/**
		 * Registrierung der GLUT-Callback-Routinen.
		 */
		static void registerCallbacks ()
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

			/* Timer-Callback - wird einmalig nach msescs Millisekunden ausgefuehrt */
			glutTimerFunc (1000 / TIMER_CALLS_PS,         /* msecs - bis Aufruf von func */
						   cbTimer,                       /* func  - wird aufgerufen    */
						   glutGet (GLUT_ELAPSED_TIME));  /* value - Parameter, mit dem
														   func aufgerufen wird */

			/* Reshape-Callback - wird ausgefuehrt, wenn neu gezeichnet wird (z.B. nach
			 * Erzeugen oder Groessenaenderungen des Fensters) */
			 
			glutReshapeFunc (cbReshape);

			/* Display-Callback - wird an mehreren Stellen imlizit (z.B. im Anschluss an
			 * Reshape-Callback) oder explizit (durch glutPostRedisplay) angestossen */
			glutDisplayFunc (cbDisplay);
		}

		/**
		 * Initialisiert das Programm (inkl. I/O und OpenGL) und startet die
		 * Ereignisbehandlung.
		 *
		 * @param title Beschriftung des Fensters
		 * @param width Breite des Fensters
		 * @param height Hoehe des Fensters
		 * @return ID des erzeugten Fensters, false im Fehlerfall
		 */
		public bool initAndStart (string title, int width, int height)
		{
			int windowID = 0;
			/* Kommandozeile immitieren */
			int argc = 1;
			string[] argv = {"cmd"};

			/* Glut initialisieren */
			glutInit (ref argc, argv);

			/* Initialisieren des Fensters */
			/* RGB-Framewbuffer, Double-Buffering und z-Buffer anfordern */
			glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
			glutInitWindowSize (width, height);
			glutInitWindowPosition (0, 0);
			
			/* SDL initialisieren *
			if (SDL.init(SDL.InitFlag.EVERYTHING) != 0) {
				print("Unable to initialize SDL: %s\n", SDL.get_error());
				return true;
			}
			if (SDLImage.init(0) != 0) {
				print("Unable to initialize SDL-Image: %s\n", SDLImage.get_error());
				return true;
			}*/
			
			/* Fenster erzeugen */
			windowID = glutCreateWindow (title);

			/* Gibt die aktuelle Fenstergroesse an WORLD.STATE.VIEWPORT zurueck*/
			glGetIntegerv( GL_VIEWPORT, WORLD.STATE.VIEWPORT );

			if (windowID != 0) {
				/* Welt initialisieren */
				WORLD.init();
				/* Logik initialisieren */
				//initLogic ();
				/* Szene initialisieren */
				if (Scene.init ()) {
					/* Callbacks registrieren */
					registerCallbacks ();
					/* Eintritt in die Ereignisschleife */
					glutMainLoop ();
				} else {
					/* Szene konnte nicht initialisiert werden */
					glutDestroyWindow (windowID);
					windowID = 0;
				}
			} else {
				/* Fenster konnte nicht erzeugt werden */
			}

			return windowID != 0;
		}
	}
}