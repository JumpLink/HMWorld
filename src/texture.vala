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

//using SDL;
//using SDLImage;
using GL;
using Gdk;
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public class Texture {
		GLuint* texID = new GLuint[1];
		GL.GLuint displaylistID;
		GLenum texture_format;
		GL.GLint read_channel = 3;
		/**
		 * Liefert den Pixbuf der Textur, Pixbuf wird fuer die Verwalltung der Pixel verwendet.<<BR>>
		 * * Weitere Informationen: [[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.html]]
		 * @see Gdk.Pixbuf
		 */
		public Pixbuf pixbuf { get; private set; }
		public double width {
			get { return pixbuf.get_width(); }
		}
		public double height {
			get { return pixbuf.get_height(); }
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public void* pixels {
			get { return pixbuf.get_pixels(); }
		}
		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public bool has_alpha {
			get { return this.pixbuf.get_has_alpha(); }
		}
		/**
		 * Liefert den Farbraum der Textur, zur Zeit wird nur RGB unterstuetzt,
		 * Weitere Informationen dazu gibt es hier:<<BR>>
		 * *[[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Colorspace.html]]<<BR>>
		 * *[[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.colorspace.html]]
		 * @see Gdk.Pixbuf.colorspace
		 */
		public Colorspace colorspace {
			get { return this.pixbuf.get_colorspace(); }
		}

		/**
		 * Konstruktor.
		 */
		public Texture() {
			glGenTextures(1, texID);
			displaylistID = glGenLists(1);
		}
		~Texture() {
			glDeleteLists(displaylistID,1);
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		public void loadFromFile(string path)
		requires (displaylistID != 0)
		ensures((bool)glIsList(displaylistID))
		{
			loadFromFileWithGdk(path);
			createDisplayList();
		}
		/**
		 * Ladet eine Textur aus einer Datei mittels Gdk.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		public void loadFromFileWithGdk(string path)
		requires (path != null)
		{
	 		try {
				pixbuf = new Pixbuf.from_file (path);
			}
			catch (GLib.Error e) {
				//GLib.error("", e.message);
				GLib.error("%s konnte nicht geladen werden", path);
			}
			
			loadFromPixbuf(pixbuf);
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
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public void loadFromPixbuf(Gdk.Pixbuf pixbuf)
		requires (pixbuf != null)
		{
			this.pixbuf = pixbuf;
			if(pixbuf.colorspace == Colorspace.RGB)
				if (has_alpha) {
					texture_format = GL_RGBA;
					read_channel = 4;
					/**/
					//texture_format = GL_BGRA;
					//print("RGBA\n");
				}
				else {
					texture_format = GL_RGB;
					read_channel = 3;
					//texture_format = GL_BGR;
					//print("RGB\n");
				}
			else {
				texture_format = 0;
				print("warning: the image is not truecolor..  this will probably break\n");
			}
		}
		/**
		 *
		 */
		public void save (string filename) {
			try {
				pixbuf.save(filename, "png");
			} catch (GLib.Error e) {
				error ("Error! Konnte Sprite nicht Speichern: %s\n", e.message);
			}
		}
		/**
		 * Bindet die Textur an OpenGL.
		 */
		public void bindTexture () {
			//print("binde textur \n");
			if (width > 1 && height > 1)
			{
				glBindTexture(GL_TEXTURE_2D, texID[0]);
				//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
				glTexImage2D(GL_TEXTURE_2D, 0, read_channel, (GL.GLsizei) width, (GL.GLsizei) height, 0, texture_format, GL_UNSIGNED_INT_8_8_8_8_REV, pixels);

				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			}
		}
		/**
		 *
		 */
		public void draw( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			draw_direct(x,y,zoff,mirror);
		}
		/**
		 *
		 */
		public void draw_list( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
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
		public void draw_direct( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
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
		/**
		 * Gibt die Werte der Textur auf der Konsole aus.
		 */
		public void printValues() {
			print("=Tex=\n");
			print(@"width: $width \n");
			print(@"height: $height \n");
			print(@"has alpha: $has_alpha \n");
		}
	}
}