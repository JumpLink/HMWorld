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

/**
 * Klasse fuer TileSets
 */
public class TileSet {

	/**
	 * Struktur fuer TileSets
	 */
	public struct Data {
		/** Name des TileSets. */
		public string name;
		/** Breite eines Tiles */
		public uint tilewidth;
		/** Hoehe eines Tiles */
		public uint tileheight;
		/** Dateiname des TileSets */
		public string source;
		/** Transparente Farbe im TileSet */
		public string trans;
		/** Gesamtbreite des TileSets */
		public uint width;
		/** Gesamthoehe des TileSets */
		public uint height;
	}

	TileSet.Data data;
	/** Array fuer die einzelnen Tiles */	
	private Tile[,]	 tiles;

	/**
	 * Konstruktor
	 */
	public TileSet() {
		//tiles = new Tile[,];
	}
	
	public void loadTileSetFromFile(string path) {
	
		var xml = new HMPXml ();
		data = xml.getTileSetDataFromFile(path);
	}
	
	public void printValues() {
		print("name: %s\n", data.name);
		print("tilewidth: %u", data.tilewidth);
		print("tileheight: %u", data.tileheight);
		print("source: %s\n", data.source);
		print("trans: %s\n", data.trans);
		print("width: %u", data.width);
		print("height: %u", data.height);
	}
}
