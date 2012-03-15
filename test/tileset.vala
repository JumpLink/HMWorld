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
	 * Klasse fuer TileSets Tests
	 */
	public class TileSetTest {

		/**
		 * Konstruktor
		 */
		public TileSetTest() {
			print("Erstelle TileSet Test-Objekt\n");
		}
		public void test_a() {
			print("test_a:\n");
			var tileset = new HMP.TileSet();
			tileset.loadFromPath("./test/data/tileset/", "Stadt - Sommer.tsx");
			var tile_a = tileset.getTileFromIndex(302);
			tile_a.printValues();
		}
		public void test_b() {
			print("test_b:\n");
			var tileset = new HMP.TileSet();
			tileset.loadFromPath("./test/data/tileset/", "Stadt - Sommer.tsx");
			var tile_a = tileset.getTileFromIndex(354);
			tile_a.printValues();
		}
	}
}