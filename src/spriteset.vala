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
using HMP;
namespace HMP {
	/**
	 * Klasse fuer SpriteSets
	 */
	public class SpriteSet {

		/**
		 * Klasse fuer XML-Operationen
		 */
		class XML : HMP.XML {
			public XML(string path) {
				base(path);
			}
		}

		/**
		 * Name des SpriteSets.
		 */
		public string name;
		/**
		 * Breite eines Sprites
		 */
		public uint spritewidth;
		/**
		 * Hoehe eines Sprites7
		 */
		public uint spriteheight;
		/**
		 * Dateiname des SpriteSets
		 */
		public string source;
		/**
		 * Transparente Farbe im SpriteSets
		 */
		public string trans;
		/**
		 * Gesamtbreite des SpriteSets
		 */
		public uint width;
		/**
		 * Gesamthoehe des SpriteSets
		 */
		public uint height;

		/**
		 * Array fuer die einzelnen Sprites
		 */	
		private Sprite[,] sprites;

		/**
		 * Konstruktor
		 */
		public SpriteSet() {
			getSpriteSetFromFile ("foobar");
			//tiles = new Tile[,];
		}
		/**
		 * Konstruktor welcher direkt ein angegebenes SpriteSet ladet
		 *
		 * @param path String mit Pfadangabe fuer die zu Ladene Datei
		 */
		public SpriteSet.fromFile(string path) {
			getSpriteSetFromFile (path);
			//tiles = new Tile[,];
		}
		/**
		 * Ladet ein SpriteSet von einer Datei
		 *
		 * @param path String mit Pfadangabe fuer die zu Ladene Datei
		 */
		public void getSpriteSetFromFile(string path) {
			//TODO
		}
	}
}