/* Copyright (C) 2012  Pascal Garber
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 */
using HMP;
using GL;
using GLU;
using GLUT;
namespace HMP {
	public class OpenGLView:View {
		static int windowID = 0;
		static bool _perspective = false;
		public override bool perspective {
			get {
				return _perspective;
			}
			protected set {
				_perspective = value;
			}
		}
		/**
		 * viewport.
		 */
		static int[] viewport = new int[4];
		/**
		 * Fensterbreite.
		 */
		public override int window_width {
			get { return viewport[2]; }
			set { viewport[2] = value;}
		}
		/**
		 * Fensterhoehe.
		 */
		public override int window_height {
			get { return viewport[3]; }
			set { viewport[3] = value;}
		}

		public OpenGLView() {
		}

		public override void toggle_perspective() {
			perspective = toggle (perspective);
			print(@"Perspektive: $(perspective)");
		}
		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		public override void show () {
			/* Eintritt in die Ereignisschleife */
			glutMainLoop ();
		}
		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		static new void draw () {

			/* Colorbuffer leeren */
			glClear (GL_COLOR_BUFFER_BIT);

			/* Nachfolgende Operationen beeinflussen Modelviewmatrix */
			glMatrixMode (GL_MODELVIEW);

			/* Welt zeichen */
			drawWorld(WORLD);

			/* Szene anzeigen / Buffer tauschen */
			glutSwapBuffers ();
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
			if (!_perspective) {
				glOrtho (	0, viewport[2],						/* links, rechts */
						 	viewport[3], 0,						/* unten, oben */
							-128, 128);											/* tiefe */
				/* verschiebt die Welt in die Mitte	 */
				if (viewport[2] > WORLD.CURRENT_MAP.pxl_width)
					glTranslatef((GL.GLfloat)WORLD.CURRENT_MAP.shift_x,0,0);
				if (viewport[3] > WORLD.CURRENT_MAP.pxl_height)
					glTranslatef(0,(GL.GLfloat)WORLD.CURRENT_MAP.shift_y,0);
			} else {
				gluPerspective (100.0f, (float) viewport[2]/viewport[3], -128, 128 );
				gluLookAt(viewport[2]/2, viewport[3], -128, viewport[2]/2, 0, 128, 0,-1,0);
			}
		}
		public override void timer (int lastCallTime) {
			cbTimer(lastCallTime);
		}
		/**
		 * Timer-Callback.
		 * Initiiert Berechnung der aktuellen Position und Farben und anschliessendes
		 * Neuzeichnen, setzt sich selbst erneut als Timer-Callback.
		 *
		 * @param lastCallTime Zeitpunkt, zu dem die Funktion als Timer-Funktion
		 *   registriert wurde (In).
		 */
		static void cbTimer (int lastCallTime)
		{
			/* Seit dem Programmstart vergangene Zeit in Millisekunden */
			int thisCallTime = glutGet (GLUT_ELAPSED_TIME);
			/* Seit dem letzten Funktionsaufruf vergangene Zeit in Sekunden */
			STATE.interval = (double) (thisCallTime - lastCallTime) / 1000.0f;

			/* neue Position berechnen (zeitgesteuert) */
			WORLD.timer ();

			/* Wieder als Timer-Funktion registrieren, falls nicht pausiert */
			if(!STATE.paused)
				glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);

			/* Neuzeichnen anstossen */
			glutPostRedisplay ();
		}
		public override void reshape (int w, int h) {
			cbReshape(w,h);
		}
		/**
		 * Callback fuer Aenderungen der Fenstergroesse.
		 * Initiiert Anpassung der Projektionsmatrix an veränderte Fenstergroesse.
		 * @param w Fensterbreite (In).
		 * @param h Fensterhoehe (In).
		 */
		static void cbReshape (int w, int h)
		{
			/* Das ganze Fenster ist GL-Anzeigebereich */
			glViewport (0, 0, (GLsizei) w, (GLsizei) h);
			/* Gibt die aktuelle Fenstergroesse an viewport zurueck*/
			glGetIntegerv( GL_VIEWPORT, viewport );
			/* Anpassen der Projektionsmatrix an das Seitenverhältnis des Fensters */
			setProjection ();
			//print("- Fensterinhalt nach groesse angepasst -");
		}

		/**
		 * Registrierung der GLUT-Callback-Routinen.
		 */
		static void registerCallbacks ()
		{
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
			glutDisplayFunc (draw);

			HMP.OpenGLInput.registerCallbacks();
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
		public override bool init(string[] args, string title, int width, int height)
		{
			/* Glut initialisieren */
			glutInit (ref args.length, args);

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

			/* Gibt die aktuelle Fenstergroesse an viewport zurueck*/
			glGetIntegerv( GL_VIEWPORT, viewport );

			if (windowID != 0) {
				/* Logik initialisieren */
				//initLogic ();
				/* Szene initialisieren */
				if (initScene()) {
					/* Callbacks registrieren */
					registerCallbacks ();
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
		/**
		 * Zeichnen einer Zeichfolge in den Vordergrund. Gezeichnet wird mit Hilfe von
		 * <code>glutBitmapCharacter(...)</code>. Kann wie <code>printf genutzt werden.</code>
		 * @param x x-Position des ersten Zeichens 0 bis 1 (In).
		 * @param y y-Position des ersten Zeichens 0 bis 1 (In).
		 * @param color Textfarbe (In).
		 * @param str Formatstring fuer die weiteren Parameter (In).
		 */
		static void drawString (GLfloat x, GLfloat y, GLfloat[] color, string str)
		{
			GLint matrixMode = 0;             /* Zwischenspeicher akt. Matrixmode */

			/* aktuelle Zeichenfarbe (u.a. Werte) sichern */
			glPushAttrib (GL_COLOR_BUFFER_BIT | GL_CURRENT_BIT | GL_ENABLE_BIT);

			/* aktuellen Matrixmode speichern */
			glGetIntegerv (GL_MATRIX_MODE, &matrixMode);
			glMatrixMode (GL_PROJECTION);

			/* aktuelle Projektionsmatrix sichern */
			glPushMatrix ();

			/* neue orthogonale 2D-Projektionsmatrix erzeugen */
			glLoadIdentity ();
			gluOrtho2D (0.0, 1.0, 1.0, 0.0);

			glMatrixMode (GL_MODELVIEW);

			/* aktuelle ModelView-Matrix sichern */
			glPushMatrix ();

			/* neue ModelView-Matrix zuruecksetzen */
			glLoadIdentity ();

			/* Tiefentest ausschalten */
			glDisable (GL_DEPTH_TEST);

			/* Licht ausschalten */
			glDisable (GL_LIGHTING);

			/* Nebel ausschalten */
			glDisable (GL_FOG);

			/* Blending ausschalten */
			glDisable (GL_BLEND);

			/* Texturierung ausschalten */
			glDisable (GL_TEXTURE_1D);
			glDisable (GL_TEXTURE_2D);
			/* glDisable (GL_TEXTURE_3D); */

			/* neue Zeichenfarbe einstellen */
			glColor4fv (color);

			/* an uebergebenene Stelle springen */
			glRasterPos2f (x, y);

			/* Zeichenfolge zeichenweise zeichnen */
			//for (uint i = 0; i < str.length; i++)
			{
				//glutBitmapCharacter (GLUT_BITMAP_HELVETICA_18, str[i]);
			}

			/* alte ModelView-Matrix laden */
			glPopMatrix ();
			glMatrixMode (GL_PROJECTION);

			/* alte Projektionsmatrix laden */
			glPopMatrix ();

			/* alten Matrixmode laden */
			glMatrixMode (matrixMode);

			/* alte Zeichenfarbe und Co. laden */
			glPopAttrib ();
		}
		/**
		 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
		 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
		 * OpenGL-Statusmaschine.
		 * @return Rueckgabewert: im Fehlerfall 0, sonst 1, glaube ich..
		 */
		protected bool initScene ()
		{
			/* Setzen der Farbattribute */
			/**
			 * Hintergrundfarbe
			 */
			glClearColor (colBG[ColorIndex.R], colBG[ColorIndex.G], colBG[ColorIndex.B], colBG[ColorIndex.A]);
			/**
			 * Zeichenfarbe
			 */
			glColor3f (1.0f, 1.0f, 1.0f);

			/**
			 * Vertexarrays erlauben
			 */
			glEnableClientState (GL_VERTEX_ARRAY);

			/* Polygonrueckseiten nicht anzeigen */
			/*glCullFace (GL_BACK);
			glEnable (GL_CULL_FACE);*/
			
			glEnable(GL_TEXTURE_2D);

			/* Alphakanal fuer Texturen aktivieren */
			glEnable(GL_ALPHA_TEST);
			/* Wertebereich fuer Transparenz*/
			glAlphaFunc(GL_GREATER, (GL.GLclampf) 0.1);
			/*Blending gegen Verdeckung*/
			glEnable(GL_BLEND);
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			/* Rueckseiten nicht zeichnen*/
			glEnable(GL_CULL_FACE);
			glCullFace(GL_BACK);
			/*---Tiefentest---*/
			/* Tiefentest aktivieren */
			//glEnable(GL_DEPTH_TEST);
			/* Fragmente werden gezeichnet, wenn sie einen größeren oder gleichen Tiefenwert haben.  */
			//glDepthFunc(GL_GEQUAL);

			/* VORERST DEAKTIVIERT */
			glDisable(GL_DEPTH_TEST);
			glDepthFunc(GL_ALWAYS);
			/**
			 * Alles in Ordnung?
			 */
			return (glGetError() == GL_NO_ERROR);
		}
		protected new static void drawTile(HMP.Tile tile, double x, double y, double zoff) {
			if (tile.type != TileType.NO_TILE)
				tile.tex.draw((int)x,(int)y,zoff);
				print("OpenGL-Tike");
		}
	}
}
