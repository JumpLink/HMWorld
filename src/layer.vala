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
 * Klasse fuer Maplayer.
 */
public class Layer {
	/**
	 * Name des Layers
	 */
	public string name;
	/**
	 * z-offset zum Zeichnen dieses Layers
	 */
	public double zoff;
	/**
	 * Breite des Layers
	 */
	public uint sizeX;
	/**
	 * Hoehe des Layers
	 */
	public uint sizeY;
	/**
	 * Tiles des Layers
	 */
	public Tile[,] tiles;

	/**
	 * Konstruktor
	 */
	public Layer() {
		name = "new Layer";
		zoff = 0;
		sizeX = 10;
		sizeY = 10;
		tiles = new Tile[sizeX, sizeY];
	}

	/**
	 * Konstruktor mit Groessenangaben
	 */
	public Layer.sized(int sizeX, int sizeY) {
		name = "new Layer";
		zoff = 0;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		tiles = new Tile[sizeX, sizeY];
	}

	/**
	 * Konstruktor mit allen Werten non-default
	 */
	public Layer.all(string name, double zoff, int sizeX, int sizeY) {
		this.name = "new Layer";
		this.zoff = 0;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		tiles = new Tile[sizeX, sizeY];
	}

	public void calcEdges () {
		uint[] neighbours = new uint[8];
		for (uint r = 0; r < sizeY; ++r)
			for (uint c = 0; c < sizeX; ++c) {
				neighbours[0] = ( c != 0 ) ? tiles[c - 1, r].type : EMPTY_TILE;
				neighbours[1] = (c != 0 && r != 0 ) ? tiles[c - 1, r - 1].type : EMPTY_TILE;
				neighbours[2] = ( r != 0 ) ? tiles[c, r - 1].type : EMPTY_TILE;
				neighbours[3] = ( r != 0 && c < sizeX ) ? tiles[c + 1, r - 1].type : EMPTY_TILE;
				neighbours[4] = ( c < sizeX ) ? tiles[c + 1, r].type : EMPTY_TILE;
				neighbours[5] = ( r < sizeY && c < sizeX ) ? tiles[c + 1, r + 1].type : EMPTY_TILE;
				neighbours[6] = ( r < sizeY ) ? tiles[c, r + 1].type : EMPTY_TILE;
				neighbours[7] = ( r < sizeY && c != 0 ) ? tiles[c - 1, r + 1].type : EMPTY_TILE;
				tiles[c, r].calcEdges(neighbours);
			}
	}
}
