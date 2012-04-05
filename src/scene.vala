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
using HMP;
namespace HMP {
	namespace Scene {
		/**
		 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
		 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
		 * OpenGL-Statusmaschine.
		 * @return Rueckgabewert: im Fehlerfall 0, sonst 1, glaube ich..
		 */
		static bool init ()
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
	}
}
