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
using Gdk;
using GL;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer nicht unterteilte Tiles
	 */
		public class RegularTile : Tile {
			/**
			 * Konstruktor erzeugt standardmaessig ein Tile vom Typ HMP.TileType.NO_TILE
			 * mit einer leeren Textur
			 * @see HMP.TileType.EMPTY_TILE
			 */
			public RegularTile () {
				tex = new Texture();
				type = HMP.TileType.NO_TILE;
			}
			/**
			 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
			 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
			 */
			public RegularTile.FromPixbuf (Pixbuf pixbuf) {
				tex = new Texture();
				tex.loadFromPixbuf(pixbuf);
				type = HMP.TileType.EMPTY_TILE;
			}
			/**
			 * Gibt den Pixelbufer der Textur zurueck
			 * @return Die vom tile verwendete Textur als Pixbuf
			 */
			public Pixbuf get_Pixbuf () {
				return tex.get_Pixbuf();
			}
			/**
			 * {@inheritDoc}
			 * @see HMP.Tile.printValues
			 */
			public override void printValues (){
				print("ich bin ein RegularTile: ");
				//print("gid: %u",gid);
				print("type: %u\n",type);
				if(type != TileType.NO_TILE) {
					tex.printValues();
				}
			}
			/**
			 * {@inheritDoc}
			 * @see HMP.Tile.save
			 */
			public override void save (string filename) {
				if(type != TileType.NO_TILE) {
					try {
						get_Pixbuf().save(filename, "png");
					} catch (GLib.Error e) {
						error ("Error! Konnte Tile nicht Speichern: %s\n", e.message);
					}
				}
			}
			/**
			 * {@inheritDoc}
			 * @see HMP.Tile.draw
			 */
			public override void draw( double x, double y, double zoff) {
				double width = get_width();
				double height = get_height();
				if(type != TileType.NO_TILE) {
					//print("draw aus RefTile!\n");
					tex.bindTexture();
					glBegin (GL_QUADS);
						/*Farbe fuers Blending*/
						//glBlendColor(0,0,0,0);
						glTexCoord2d(0,0);
							glVertex3d ( x, y, zoff);
						glTexCoord2d(0,1);
							glVertex3d ( x, y + height, zoff);
						glTexCoord2d(1,1);
							glVertex3d ( x + width, y + height, zoff);
						glTexCoord2d(1,0);
							glVertex3d ( x + width, y, zoff);

				    glEnd ();
				    } else {
				    	//print("Tile ist kein Tile zum zeichnen\n");
				    }
			}
			/**
			 * {@inheritDoc}
			 * @see HMP.Tile.calcEdges
			 */
			public override void calcEdges (TileType[] neighbours) {
				//nichts
			}
	}
}