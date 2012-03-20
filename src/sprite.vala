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
using GL;	
using HMP;
namespace HMP {
	public Texture tex;
	/**
	 * Allgemeine Klasse fuer Sprites
	 */
	public class Sprite {
		/**
		 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
		 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
		 */
		public Sprite (Pixbuf pixbuf) {
			tex = new Texture();
			tex.loadFromPixbuf(pixbuf);
			//type = HMP.TileType.EMPTY_TILE;
		}
		/**
		 * Gibt die Breite eines Sprites zurueck.
		 * @return Brteite des Sprites 
		 */
		public double get_width() {
			return tex.get_width();
		}
		/**
		 * Gibt die Hoehe eines Sprites zurueck.
		 * @return Hoehe des Sprites 
		 */
		public double get_height() {
			return tex.get_height();
		}
		/**
		 * Gibt den Pixelbufer der Textur zurueck
		 * @return Die vom tile verwendete Textur als Pixbuf
		 */
		public Pixbuf get_Pixbuf () {
			return tex.get_Pixbuf();
		}
		/**
		 * 
		 * @see HMP.Tile.printValues
		 */
		public void printValues (){
			print("ich bin ein Sprite: ");
			tex.printValues();
		}
		public void printAll (){
			printValues();
		}
		/**
		 * 
		 * @see HMP.Tile.save
		 */
		public void save (string filename) {
			//if(type != TileType.NO_TILE) {
				try {
					get_Pixbuf().save(filename, "png");
				} catch (GLib.Error e) {
					error ("Error! Konnte Sprite nicht Speichern: %s\n", e.message);
				}
			//}
		}
		/**
		 * 
		 * @see HMP.Tile.draw
		 */
		public void draw( double x, double y, double zoff) {

		}
	}
}