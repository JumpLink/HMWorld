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
	/** Name des Layers */
	public string name;
	/** z-offset zum Zeichnen dieses Layers */
	public double zoff;
	/** Breite des Layers */
	public int sizeX;
	/** Hoehe des Layers */
	public int sizeY;
	/** Tiles des Layers */
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
}
