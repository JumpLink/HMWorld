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
using Xml;
using Xml.XPath;
using Gee;

namespace HMP {
	/**
	 * Klasse fuer Maps.
	 * Diese Klasse dient zur Speicherung von Mapinformationen.
	 * Sie kann zudem die Maps auf der Konsole ausgeben und eine Map-Datei laden.
	 */
	public class Map {
		/**
		 * orientation der Map.
		 */
		public string orientation;
		/**
		 * Version des Kartenformats, fuer gewoehnloch 1.0
		 */
		public string version;
		/**
		 * Gesamtbreite der map
		 */
		public uint width;
		/**
		 * Gesamthoehe der Map
		 */
		public uint height;
		/**
		 * Breite eines Tiles
		 */
		public uint tilewidth;
		/**
		 * Höhe eines Tiles
		 */
		public uint tileheight;
		/**
		 * Dateiname der Map
		 */
		public string filename;
		/**
		 * Tilesets die für auf der Map verwendet werden
		 */
		public Gee.List<HMP.TileSetReference> tileset;
		/**
		 * Layer der Map.
		 */
		public Gee.List<Layer> layers;
		/** 
		 * Entities auf der Map
		 */
		public Gee.List<Entity> entities;

		/**
		 * Konstruktor fuer eine leere Map
		 */
		public Map() {
			print("Erstelle leeres Map Objekt\n");
			layers = new Gee.ArrayList<Layer>();
			entities = new Gee.ArrayList<Entity>();
			tileset = new Gee.ArrayList<TileSetReference>();
		}
		/**
		 * Konstrukter, ladet Map mit Daten einer Mapdatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param fn Der Dateiname der gelesen werden soll
		 */
		public Map.fromPath (string folder = "./data/map/", string fn) {
			print("Lade Mapdateien von %s + %s\n", folder, fn);

			this.filename = fn;
			TMX xml = new TMX(folder+filename);
			xml.loadGlobalMapProperties(out orientation, out version, out width, out height, out tilewidth, out tileheight);
			tileset = xml.loadTileSets();
			layers = xml.loadLayers(tileset);
		}
		/**
		 * Gibt das zur gid passende TileSetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids
		 * @param tilesetrefs Liste von TileSetReference's in der gesucht werden soll.
		 * @param gid Die zu der das passende TileSet gesucht werden soll.
		 * @return Das gefundene TileSetReference.
		 */
		public static TileSetReference getTileSetRefFromGid(Gee.List<HMP.TileSetReference> tilesetrefs, uint gid) {	
			HMP.TileSetReference found = tilesetrefs[0];
			foreach (HMP.TileSetReference tsr in tilesetrefs) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			//print("Das passende TileSet ist %s\n", found.source.name);
			return found;
		}
		/**
		 * Gibt den Index eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Index aus der Layerliste
		 */
		public int getIndexOfLayerName(string name) {
			foreach (Layer i in layers) {
				if (name == i.name) {
					return layers.index_of(i);
				}
			}
			return -1;
		}
		/**
		 * Die draw-Methode der Layer-Klasse durchlaeuft seine enthaltenen Layers und ruft jeweils ihre eigene draw-Methode
		 * mit ihrer entsprechenden Verschiebung auf und Zeichnet somit die komplette Map.
		 * @see HMP.Layer.draw
		 * @see HMP.Tile.draw
		 */
		public void draw() {
			//print("==DrawMap==\n");
			int shift_x = (int) (WORLD.STATE.VIEWPORT[2] - width * tilewidth)/2;
			int shift_y = (int) (WORLD.STATE.VIEWPORT[3] - height * tileheight)/2;
			foreach (Layer l in layers) {
				l.draw(shift_x, shift_y);
			}
			foreach (Entity e in entities) {
				e.draw (shift_x, shift_y, 0.0);
			}
			//layers[0].draw();
		}
		/**
		 * Gibt alle Werte (bis auf die Layer) der Map auf der Konsole aus
		 */
		public void printValues() {
			print("==MAP==\n");
			print("filename: %s\n", filename);
			print("orientation: %s\n", orientation);
			print("version: %s\n", version);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("tilewidth: %u\n", tilewidth);
			print("tileheight: %u\n", tileheight);
		}
		/**
		 * Gibt die Werte aller Layer der Map auf der Konsole aus
		 */
		public void printLayers() {
			print("====ALL LAYERS FROM MAP %s====\n", filename);
			foreach (HMP.Layer l in layers) {
				l.printValues();
				l.printTiles();
			}
		}
		/**
		 * Gibt die Werte aller TileSets der Map auf der Konsole aus
		 */
		public void printTileSets() {
			print("====ALL TILESETS FROM MAP %s====\n", filename);
			foreach (HMP.TileSetReference tsr in tileset) {
				tsr.printValues();
			}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printLayers();
			printTileSets();
		}
	}
}
