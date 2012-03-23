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
		public uint width;
		/**
		 * Hoehe des Layers
		 */
		public uint height;
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
			width = 10;
			height = 10;
			tiles = new Tile[width, height];
		}

		/**
		 * Konstruktor mit Groessenangaben
		 */
		public Layer.sized(int width, int height) {
			name = "new Layer";
			zoff = 0;
			this.width = width;
			this.height = height;
			tiles = new Tile[width, height];
		}

		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public Layer.all(string name, double zoff, int width, int height, Tile[,] tiles) {
			this.name = name;
			this.zoff = zoff;
			this.width = width;
			this.height = height;
			this.tiles = tiles;
		}
		/*
		 * TODO OLE
		 */
		public void calcEdges () {
			TileType[] neighbours = new TileType[8];
			for (uint r = 0; r < height; ++r)
				for (uint c = 0; c < width; ++c) {
					neighbours[0] = ( c != 0 ) ? tiles[c - 1, r].type : TileType.EMPTY_TILE;
					neighbours[1] = (c != 0 && r != 0 ) ? tiles[c - 1, r - 1].type : TileType.EMPTY_TILE;
					neighbours[2] = ( r != 0 ) ? tiles[c, r - 1].type : TileType.EMPTY_TILE;
					neighbours[3] = ( r != 0 && c < width ) ? tiles[c + 1, r - 1].type : TileType.EMPTY_TILE;
					neighbours[4] = ( c < width ) ? tiles[c + 1, r].type : TileType.EMPTY_TILE;
					neighbours[5] = ( r < height && c < width ) ? tiles[c + 1, r + 1].type : TileType.EMPTY_TILE;
					neighbours[6] = ( r < height ) ? tiles[c, r + 1].type : TileType.EMPTY_TILE;
					neighbours[7] = ( r < height && c != 0 ) ? tiles[c - 1, r + 1].type : TileType.EMPTY_TILE;
					tiles[c, r].calcEdges(neighbours);
				}
		}
		/**
		 * Die draw-Methode der Layer-Klasse durchlaeuft seine enthaltenen Tiles und ruft jeweils ihre eigene draw-Methode
		 * mit ihren entsprechenden Koordinaten auf und Zeichnet somit das komplette Layer.
		 * @param shift_x Verschiebung in X-Richtung. wird verwendet um die Layerposition im Bildschirm zu bestimmen,
		 * sie wird meistens dazu verwendet den Layer innerhalb des Fensters mittig zu verschieben.
		 * @param shift_y wie shift_x nur in y-Richtung.
		 * @see HMP.Map.draw
		 * @see HMP.Tile.draw
		 */
		public void draw(int shift_x, int shift_y) {
			//print("draw layer\n");
			for (int y=0;y<height;y++) {
				for (int x=0;x<width;x++) {
					if(tiles[y,x].type != TileType.NO_TILE) {
						//print("x: %i y: %i\n", x,y);
						//tiles[x,y].printValues();
						tiles[y,x].draw(shift_x + x * tiles[y,x].width, shift_y + y * tiles[y,x].height, zoff);
					}
				}
			}
		}
		/**
		 * Gibt alle Werte des Layers (bis auf die Tiles) auf der Konsole aus
		 */
		public void printValues() {
			print("==Layer==\n");
			print("name: %s\n", name);
			print("zoff: %f\n", zoff);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt die Tiles des Layers auf der Konsole aus
		 */
		public void printTiles() {
			print("==Tiles==\n");
			for (int y=0;y<height;y++) {
				for (int x=0;x<width;x++) {
					print("%u ", tiles[y,x].type);
				}
				print("\n");
			}
		}
		/**
		 * Gibt alle Werte des Layers und dessen Tiles auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printTiles();
		}
	}
}