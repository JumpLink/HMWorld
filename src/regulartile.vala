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
/**
 * Klasse fuer nicht unterteilte Tiles
 */
	public class RegularTile : Tile {
		/** Tiletyp */
		public Texture tex;
		/**
		 * Konstruktor 
		 */
		public RegularTile () {
			type = 0;
			tex = new Texture();
		}

		public RegularTile.FromPixbuf (Pixbuf pixbuf) {
			tex = new Texture();
			tex.loadFromPixbuf(pixbuf);
			type = 0;
		}

		public Pixbuf get_Pixbuf () {
			return tex.get_Pixbuf();
		}

		public override void calcEdges (uint[] neighbours) {
			//nichts
		}
}