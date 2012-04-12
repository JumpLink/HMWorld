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
		int windowID = 0;
		/**
		 * Viewport.
		 */
		public static GL.GLint[] viewport = new GL.GLint[4];
		/**
		 * Fensterbreite.
		 */
		static new int window_width {
			get { return viewport[2]; }
			set { viewport[2] = value;}
		}
		/**
		 * Fensterhoehe.
		 */
		static new int window_height {
			get { return viewport[3]; }
			set { viewport[3] = value;}
		}
		public OpenGLView() {
			//window_height = height;
			//window_width = width;
			//init(title,width,height);
		}
		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		public override void show ()
		requires(windowID != 0)
		{
			glutMainLoop ();
		}
		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		public static void draw () {

			/* Colorbuffer leeren */
			glClear (GL_COLOR_BUFFER_BIT);

			/* Nachfolgende Operationen beeinflussen Modelviewmatrix */
			glMatrixMode (GL_MODELVIEW);

			/* Welt zeichen */
			drawWorld(WORLD);
			/* Szene anzeigenshift_x / Buffer tauschen */
			glutSwapBuffers ();
		}
		public static void drawWorld(HMP.World world)
		requires (WORLD.CURRENT_MAP != null)
		{
			/* map zeichen */
			drawMap(WORLD.CURRENT_MAP);
		}
		public static void drawMap(HMP.Map map)
		requires (map != null)
		requires (map.layers_same != null)
		requires (map.layers_under != null)
		requires (map.layers_over != null)
		requires (map.layers_same[0] != null)
		requires (map.layers_under[0] != null)
		requires (map.layers_over[0] != null)
		requires (map.entities != null)
		requires (map.entities[0] != null)
		{
			//print("==DrawMap==\n");
			foreach (Layer l in map.layers_over) {
				drawLayer(l, 0, 0);
			}
			foreach (Layer l in map.layers_same) {
				drawLayer(l, 0, 0);
			}
			foreach (Entity e in map.entities) {
				drawEntity(e, 0, 0, 0);
			}
			foreach (Layer l in map.layers_under) {
				drawLayer(l, 0, 0);
			}
			for (uint x = 0; x < map.width; ++x)
				for (uint y = 0; y < map.height; ++y) {
					LogicalTile t = map.tiles[x,y];
					if (t != null && t.type == TileType.PLANT && t.plant != null)
						drawSpriteSet(t.plant.spriteset, x * WORLD.CURRENT_MAP.tilewidth, y * WORLD.CURRENT_MAP.tileheight, 0/*zoff*/);
				}
		}
		/**
		 * Die draw-Methode fuer die Layer-Klasse durchlaeuft seine enthaltenen Tiles und ruft jeweils ihre eigene draw-Methode
		 * mit ihren entsprechenden Koordinaten auf und Zeichnet somit das komplette Layer.
		 * @param shift_x Verschiebung in X-Richtung. wird verwendet um die Layerposition im Bildschirm zu bestimmen,
		 * sie wird meistens dazu verwendet den Layer innerhalb des Fensters mittig zu verschieben.
		 * @param shift_y wie shift_x nur in y-Richtung.
		 * @see HMP.Map.draw
		 * @see HMP.Tile.draw
		 */
		public static void drawLayer(HMP.Layer layer, int shift_x, int shift_y) {
			//print("draw layer\n");
			for (int y=0;y<layer.height;y++) {
				for (int x=0;x<layer.width;x++) {
					if(layer.tiles[x,y].type != TileType.NO_TILE) {
						//print("x: %i y: %i\n", x,y);
						//tiles[x,y].printValues();
						drawTile(layer.tiles[x,y], shift_x + x * layer.tiles[x,y].width, shift_y + y * layer.tiles[x,y].height, layer.zoff);
					}
				}
			}
		}
		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 * @param zoff Angabe der hoehe des Tiles Z.B unter, ueber, gleich, .. dem Held.
		 */
		public static void drawTile(HMP.Tile tile, double x, double y, double zoff) {
			if (tile.type != TileType.NO_TILE)
				tile.tex.draw((int)x,(int)y,zoff);
		}
		public static void drawEntity(HMP.Entity e, double x, double y, double zoff) {
			drawSpriteSet(e.spriteset, e.pos.x + x, e.pos.y + y, zoff);
		}
		public static void drawSpriteSet(HMP.SpriteSet ss, double x, double y, double zoff)
		requires (ss.current_animation != null)
		{
			AnimationData ani = ss.current_animation.get_AnimationData();
			double layer_zoff;
			foreach (SpriteLayer sl in ss.spritelayers) {
				if (sl.active) {
					/* zoff des Layers wird als Kommawert zum zoff dazu addiert*/
					layer_zoff = zoff; // - (sl.number / 100);
					drawSprite(sl.sprites[(uint) ani.coord.y, (uint) ani.coord.x], x, y, zoff, ani.mirror);
				}
				
				
			}
		}
		/**
		 * 
		 */
		public static void drawSprite(HMP.Sprite s, double x, double y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			s.tex.draw (Round(x-s.width/2),Round(y-s.height/2),zoff,mirror);
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
		 * Setzen der Projektionsmatrix.
		 * Setzt die Projektionsmatrix fuer die Szene.
		 */
		static void setProjection ()
		{
			/* NachfolgPLAYERende Operationen beeinflussen Projektionsmatrix */
			glMatrixMode (GL_PROJECTION);
			/* Matrix zuruecksetzen - Einheitsmatrix laden */
			glLoadIdentity ();
			if (!perspective) {
				glOrtho (	0, window_width,						/* links, rechts */
						 	window_height, 0,						/* unten, oben */
							-128, 128);											/* tiefe */
				/* verschiebt die Welt in die Mitte	 */
				if (window_width > WORLD.CURRENT_MAP.pxl_width)
					glTranslatef((GL.GLfloat)WORLD.CURRENT_MAP.shift_x,0,0);
				if (window_height > WORLD.CURRENT_MAP.pxl_height)
					glTranslatef(0,(GL.GLfloat)WORLD.CURRENT_MAP.shift_y,0);
			} else {
				gluPerspective (100.0f, (float) window_width/window_height, -128, 128 );
				gluLookAt(window_width/2, window_height, -128,window_width/2, 0, 128, 0,-1,0);
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
			STATE.interval = (double) (thisCallTime - lastCallTime) / 1000.0f;

			/* neue Position berechnen (zeitgesteuert) */
			WORLD.timer ();

			/* Wieder als Timer-Funktion registrieren, falls nicht pausiert */
			if(!STATE.paused)
				glutTimerFunc (1000 / TIMER_CALLS_PS, cbTimer, thisCallTime);

			/* Neuzeichnen anstossen */
			glutPostRedisplay ();
		}

		/**
		 * Callback fuer Aenderungen der Fenstergroesse.
		 * Initiiert Anpassung der Projektionsmatrix an veränderte Fenstergroesse.
		 * @param w Fensterbreite (In).
		 * @param h Fensterhoehe (In).
		 */
		public static void cbReshape (int w, int h)
		{	
			GL.GLint[] viewport = new GL.GLint[4];
			/* Das ganze Fenster ist GL-Anzeigebereich */
			glViewport (0, 0, (GLsizei) w, (GLsizei) h);
			/* Gibt die aktuelle Fenstergroesse an viewport zurueck*/
			glGetIntegerv( GL_VIEWPORT, viewport );
			window_width = viewport[2];
			window_height = viewport[3];
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
		 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
		 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
		 * OpenGL-Statusmaschine.
		 * @return Rueckgabewert: im Fehlerfall 0, sonst 1, glaube ich..
		 */
		static bool initScene ()
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
		/**
		 * Initialisiert das Programm (inkl. I/O und OpenGL) und startet die
		 * Ereignisbehandlung.
		 *
		 * @param title Beschriftung des Fensters
		 * @param width Breite des Fensters
		 * @param height Hoehe des Fensters
		 * @return ID des erzeugten Fensters, false im Fehlerfall
		 */
		public override bool init (string title, int width, int height)
		{
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
			
			/* Fenster erzeugen */
			windowID = glutCreateWindow (title);

			/* Gibt die aktuelle Fenstergroesse an viewport zurueck*/
			glGetIntegerv( GL_VIEWPORT, viewport );

			if (windowID != 0) {
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
		public new void toggle_perspective() {
			base.toggle_perspective();
			HMP.OpenGLView.cbReshape(window_width, window_height);
		}
	}
}
