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
	 * Klasse fuer Tiles die nur auf ein bestimmtes Tile referenzieren.
	 * Diese Klasse ist gedacht fuer die Speicherung von Tileinformationen auf einer Map.
	 * Die Speicherung der Texturierung in Tiles wird vom TileSetManager uebernommen. 
	 */
	class RefTile : Tile {
		/**
		 * Konstruktor ohne Werte
		 */		
		public RefTile() {

		}
		/**
		 * Konstruktor mit gid
		 */		
		public RefTile.fromGid(uint gid) {
			this.gid = gid;
		}
		public override void draw (double x, double y, double width) {
			print("draw aus RefTile!\n");
			//TODO
		}
		public override void printValues (){
			print("ich bin ein reftile: ");
			print("gid: %u",gid);
			print("type: %u\n",type);
		}
		/**
		 * Ungenutzte Methode
		 */
		public override void calcEdges (uint[] neighbours) {
			//nichts
		}
	}
}