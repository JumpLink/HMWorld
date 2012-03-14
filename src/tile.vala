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
	 * Allgemeine Klasse fuer Tiles
	 */
	public abstract class Tile {
		/**
		 * Tiletyp
		 */
		public uint type;
		/*
		 * Tile-ID fuer Referenzierung
		 */
		public uint gid;
		/**
		 * Konstruktor 
		 */
		public Tile() {
			type = 0;
		}

		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 * @param width Breite des Tiles
		 */
		public abstract void draw (double x, double y, double width);

		public abstract void calcEdges (uint[] neighbours);
	}
}