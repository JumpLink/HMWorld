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
using Clutter;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public abstract class ClutterTexture : Texture {
		/**
		 * Liefert den Pixbuf der Textur, Pixbuf wird fuer die Verwalltung der Pixel verwendet.<<BR>>
		 * * Weitere Informationen: [[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.html]]
		 * @see Gdk.Pixbuf
		 */
		public Clutter.Texture clutter_tex { get; private set; }
		public double width {
			get {return clutter_tex.cogl_texture.get_width ();}
		}
		public double height {
			get {return clutter_tex.cogl_texture.get_height ();}
		}
		public HMP.Colorspace colorspace {
			get { return HMP.Colorspace.fromCogl(clutter_tex.pixel_format); }
		}

		public ClutterTexture() {
			clutter_tex = new Clutter.Texture();
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public void* pixels {
			get {
				uchar[] data;
				int data_size_in_bytes; //the size of the texture data in bytes
				data_size_in_bytes = clutter_tex.cogl_texture.get_data(Cogl.PixelFormat.RGBA_8888, 0, uchar[] data);
				return data;
			}
		}
		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public bool has_alpha {
			get { return colorspace.has_alpha();}
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected void loadFromFile(string path)
		requires (path != null)
		{
			clutter_tex.from_file(string path);
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