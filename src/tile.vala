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
		 * Tiletextur, die Pixel des Tiles
		 */
		public Texture tex;
		/**
		 * Tiletyp
		 */
		public TileType type;
		/**
		 * Pflanze.
		 */
		public Plant plant;
		/**
		 * Konstruktor 
		 */
		public Tile() {
			type = TileType.NO_TILE;
		}
		/**
		 * Gibt die Breite eines Tiles zurueck.
		 * @return Brteite des Tiles 
		 */
		public double get_width() {
			if (type != TileType.NO_TILE)
				return tex.get_width();
			else
				return 0;
		}
		/**
		 * Gibt die Hoehe eines Tiles zurueck.
		 * @return Hoehe des Tiles 
		 */
		public double get_height() {
			if (type != TileType.NO_TILE)
				return tex.get_height();
			else
				return 0;
		}
		/**
		 * Speichert das Tile mit dem Dateiname filename als Datei
		 * @param filename Zu verwendender Dateiname
		 */
		public abstract void save (string filename);

		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 */
		public abstract void draw (double x, double y);
		/**
		 * Gibt alle Werte eines Tiles auf der Konsole aus.
		 */
		public abstract void printValues ();

		public abstract void calcEdges (TileType[] neighbours);
	}
}