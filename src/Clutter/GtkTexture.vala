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

using GLib;
using HMP;
using GtkClutter;
using Gdk;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public abstract class GtkClutterTexture : GdkTexture {
		public GtkClutter.Texture clutter_tex { get; private set; }

		public GtkClutterTexture() {
			clutter_tex = new GtkClutter.Texture();
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected new void loadFromFile(string path) {
			((GdkTexture)this).loadFromFile (path);
			clutter_tex.set_from_pixbuf(pixbuf);
		}
		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public new void loadFromPixbuf(Gdk.Pixbuf pixbuf)
		requires (pixbuf != null)
		{
			this.pixbuf = pixbuf;
			clutter_tex.set_from_pixbuf(pixbuf);
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
		 *
		 */
		public abstract void draw( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE);

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