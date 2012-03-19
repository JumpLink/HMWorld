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
		GLenum texture_format;
		GL.GLint read_channel = 3;
		private Gdk.Pixbuf pixbuf;
		public Texture() {
			/*nicht in der bindTexture aufrufen, wir brauchen nur einmal einen neuen Namen*/
			glGenTextures(1, texID);
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		public void loadFromFile(string path) {
			loadFromFileWithGdk(path);
		}
		/**
		 * Ladet eine Textur aus einer Datei mittels Gdk.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		public void loadFromFileWithGdk(string path) {
	 		try {
				pixbuf = new Pixbuf.from_file (path);
			}
			catch (GLib.Error e) {
				//GLib.error("", e.message);
				GLib.error("%s konnte nicht geladen werden", path);
			}
			
			loadFromPixbuf(pixbuf);
		}

		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public void loadFromPixbuf(Gdk.Pixbuf pixbuf) {
			this.pixbuf = pixbuf;
			if(pixbuf.colorspace == Colorspace.RGB)
				if (pixbuf.get_has_alpha()) {
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
		 * Bindet die Textur an OpenGL.
		 */
		public void bindTexture () {
			//print("binde textur \n");
			if (get_width() > 1 && get_height() > 1)
			{
				glBindTexture(GL_TEXTURE_2D, texID[0]);
				//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

				glTexImage2D(GL_TEXTURE_2D, 0, read_channel, (GL.GLsizei) get_width(), (GL.GLsizei) get_height(), 0, texture_format, GL_UNSIGNED_INT_8_8_8_8_REV, get_pixels());

				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			}
		}
		/**
		 * Gibt die Breite der Textur zurueck.
		 * @return Breite der Textur
		 */
		public uint get_width() {
			return this.pixbuf.get_width();
		}
		/**
		 * Gibt die Hoehe der Textur zurueck.
		 */
		public uint get_height() {
			return this.pixbuf.get_height();
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public void* get_pixels() {
			return this.pixbuf.get_pixels();
		}
		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @return  True wenn die Textur einen Alphakanal, sonst false.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public bool has_alpha() {
			return this.pixbuf.get_has_alpha();
		}
		/**
		 * Liefert den Farbraum der Textur, zur Zeit wird nur RGB unterstuetzt,
		 * Weitere Informationen dazu gibt es hier:<<BR>>
		 * *[[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Colorspace.html]]<<BR>>
		 * *[[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.colorspace.html]]
		 * @return Den Farbraum, wird zur Zeit immer RGB sein.
		 * @see Gdk.Pixbuf.colorspace
		 */
		public Colorspace get_colorspace() {
			return this.pixbuf.get_colorspace();
		}
		/**
		 * Liefert den Pixbuf der Textur, Pixbuf wird fuer die Verwalltung der Pixel verwendet.<<BR>>
		 * * Weitere Informationen: [[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.html]]
		 * @return Der Pixbuf aus gdk-pixbuf.
		 * @see Gdk.Pixbuf
		 */
		public Pixbuf get_Pixbuf() {
			return this.pixbuf;
		}
		/**
		 * Gibt die Werte der Textur auf der Konsole aus.
		 */
		public void printValues() {
			print("=Tex=\n");
			print("width: %u\n", get_width());
			print("height: %u\n", get_height());
			if (has_alpha()) print("has alpha: yes\n");
		}
		/*
		 * TODO
		 */
		/*public Pixbuf[,] createSplits(int split_width, int split_height, int count_y, int count_x) {
			Pixbuf[,] splits = new Pixbuf[count_y,count_x];
			for(int y = 0; y < count_y; y++) {
				for(int x = 0; x < count_x; x++) {
					pixbuf.copy_area(split_width*count_y, split_height*count_x, split_width, split_height, splits[y,x], 0, 0);
				}
			}
			return splits;
		}*/
	}
}