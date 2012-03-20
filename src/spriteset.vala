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
using Gee;
using Gdk;	
using HMP;
namespace HMP {
	/**
	 * Klasse fuer SpriteSets
	 */
	public class SpriteSet {
		/**
		 * Dateiname des SpriteSets.
		 */
		public string filename;
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
		 * Gesamtbreite des SpriteSets
		 */
		public uint width;
		/**
		 * Gesamthoehe des SpriteSets
		 */
		public uint height;
		string version;
		/**
		 * Ein Sprite kann aus mehreren Layern bestehen, sie werden mit einer Map gespeichert,
		 * der Map-Key ist gleichzeitig der Layername.
		 */
		public Gee.List<SpriteLayer> spritelayers;
		public Gee.List<Animation> animations;
		/**
		 * Konstruktor
		 */
		public SpriteSet() {

		}
		/**
		 * Konstrukter, ladet SpriteSet mit Daten einer SpriteSetDatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param fn Der Dateiname der gelesen werden soll
		 */
		public SpriteSet.fromPath (string folder = "./data/map/", string fn) {
			print("Lade Mapdateien von %s + %s\n", folder, fn);

			this.filename = fn;
			SSX xml = new SSX(folder+filename);
			xml.loadGlobalProperties(out name, out version, out width, out height, out spritewidth, out spriteheight);
			spritelayers = xml.loadLayers();
			animations = xml.loadAnimations(width, height);
			//tileset = xml.loadTileSets();
			//layers = xml.loadLayers(tileset);
		}
		public uint get_totalHeight() {
			return (int) (height * spriteheight);
		}

		public uint get_totalWidth() {
			return (int) (width * spritewidth);
		}
		public SpriteLayer? get_baseLayer()
		requires (spritelayers != null)
		{
			foreach (SpriteLayer sl in spritelayers) {
				if (sl.type == HMP.SpriteLayerType.BASE)
					return sl;
				else return null;
			}
			return null;
		}
		/**
		 * Gibt alle Werte Tiles auf der Konsole aus
		 */
		public void printSpriteLayers()
		requires (spritelayers != null)
		{
			if (spritelayers.size > 0) {
				print("==SpriteLayer==\n");
				int count=0;
				foreach (SpriteLayer sl in spritelayers) {
					print("Nr. %i: ",count);
					sl.printAll();
					count++;
				}
			} else {
				error("Keine SpriteLayer vorhanden!\n");
			}
		}
		public void printAnimation()
		requires (animations != null)
		{
			print("==Animations==\n");
			int count=0;
			foreach (Animation ani in animations) {
				print("Nr. %i: ",count);
				ani.printAll();
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printValues() {
			print("SpriteSetValues\n");
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("spritewidth: %u\n", spritewidth);
			print("spritewidth: %u\n", spritewidth);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alle Werte und die Tiles des TileSets auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printSpriteLayers();
			printAnimation();
		}
	}
}