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

using Gdk;
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public abstract class GdkTexture : Texture {
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
		public HMP.Colorspace colorspace {
			get { return HMP.Colorspace.fromGdkPixbuf(pixbuf); }
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
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected void loadFromFile(string path)
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

		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public void loadFromPixbuf(Gdk.Pixbuf pixbuf)
		requires (pixbuf != null)
		{
			this.pixbuf = pixbuf;
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