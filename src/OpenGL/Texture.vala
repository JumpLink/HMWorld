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
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public class OpenGLTexture : GdkTexture, HMP.Texture {
		GLuint* texID = new GLuint[1];
		GL.GLuint displaylistID;
		/**
		 * Konstruktor.
		 */
		public OpenGLTexture() {
			glGenTextures(1, texID);
			displaylistID = glGenLists(1);
		}
		/**
		 * Konstruktor.
		 */
		public OpenGLTexture.FromFile(string path) {
			glGenTextures(1, texID);
			displaylistID = glGenLists(1);
			loadFromFile(path);
			createDisplayList();
		}
		public OpenGLTexture.FromPixbuf(Gdk.Pixbuf pixbuf) {
			glGenTextures(1, texID);
			displaylistID = glGenLists(1);
			loadFromPixbuf(pixbuf);
			createDisplayList();
		}
		~OpenGLTexture() {
			glDeleteLists(displaylistID,1);
		}
		private void createDisplayList() {
			glNewList(displaylistID, GL_COMPILE);
				//bindTexture();
				glBegin (GL_QUADS);
					glTexCoord2d(0,0);
						glVertex3d ( 0, 0, 0);
					glTexCoord2d(0,1);
						glVertex3d ( 0, height, 0);
					glTexCoord2d(1,1);
						glVertex3d ( width, height, 0);
					glTexCoord2d(1,0);
						glVertex3d ( width, 0, 0);
				glEnd ();
			glEndList();
		}
		/**
		 * Bindet die Textur an OpenGL.
		 */
		private void bindTexture () {
			//print("binde textur \n");
			if (width > 1 && height > 1)
			{
				glBindTexture(GL_TEXTURE_2D, texID[0]);
				//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
				glTexImage2D(GL_TEXTURE_2D, 0, colorspace.to_opengl_channel(), (GL.GLsizei) width, (GL.GLsizei) height, 0, colorspace.to_opengl(), GL_UNSIGNED_INT_8_8_8_8_REV, pixels);

				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			}
		}
		/**
		 *
		 */
		public override void draw( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			draw_direct(x,y,zoff,mirror);
		}
		/**
		 *
		 */
		private void draw_list( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			/* Ueberpruefung ob zu zeichnender Bereich innerhalb des Fensters liegt */
			if (y < WORLD.STATE.window_height && x < WORLD.STATE.window_width) {
				glPushMatrix();
					glTranslatef((GL.GLfloat)x,(GL.GLfloat)y,(GL.GLfloat)zoff);
					bindTexture();
					switch (mirror) {
						case HMP.Mirror.NONE:
							glCallList(displaylistID);
						break;
						case HMP.Mirror.VERTICAL:
							glCallList(displaylistID);
						break;
						case HMP.Mirror.HORIZONTAL:
							glCallList(displaylistID);
						break;
					}
				glPopMatrix();
			}
			//print ("%i, ",(int)displaylistID);
		}
		/**
		 *
		 */
		private void draw_direct( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			/* Ueberpruefung ob zu zeichnender Bereich innerhalb des Fensters liegt */
			if (y < WORLD.STATE.window_height && x < WORLD.STATE.window_width) {
				switch (mirror) {
					case HMP.Mirror.NONE:
						bindTexture();
						glBegin (GL_QUADS);
							glTexCoord2d(0,0);
								glVertex3d ( x, y, zoff);
							glTexCoord2d(0,1);
								glVertex3d ( x, y + height, zoff);
							glTexCoord2d(1,1);
								glVertex3d ( x + width, y + height, zoff);
							glTexCoord2d(1,0);
								glVertex3d ( x + width, y, zoff);
						glEnd ();
					break;
					case HMP.Mirror.VERTICAL:
						bindTexture();
						glBegin (GL_QUADS);
							glTexCoord2d(1,0);
								glVertex3d ( x, y, zoff);
							glTexCoord2d(1,1);
								glVertex3d ( x, y + height, zoff);
							glTexCoord2d(0,1);
								glVertex3d ( x + width, y + height, zoff);
							glTexCoord2d(0,0);
								glVertex3d ( x + width, y, zoff);
						glEnd ();
					break;
					case HMP.Mirror.HORIZONTAL:
						bindTexture();
						glBegin (GL_QUADS);
							glTexCoord2d(0,1);
								glVertex3d ( x, y, zoff);
							glTexCoord2d(0,0);
								glVertex3d ( x, y + height, zoff);
							glTexCoord2d(1,0);
								glVertex3d ( x + width, y + height, zoff);
							glTexCoord2d(1,1);
								glVertex3d ( x + width, y, zoff);
						glEnd ();
					break;
				}
			}
		}
	}
}