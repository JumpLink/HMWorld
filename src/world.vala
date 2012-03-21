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
using HMP;
namespace HMP {
	/**
	 * Klasse fuer die gesamte Welt
	 */
	public class World {
		/**
		 * Globaler TileSetManager fuer zugriff auf alle TileSets von ueberall aus.
		 */
		public TileSetManager TILESETMANAGER;
		/**
		 * Globaler MapManager fuer zugriff auf alle Maps von ueberall aus.
		 */
		public MapManager MAPMANAGER;
		/**
		 * Globale Map fuer die gerade aktive Map
		 */
		public Map CURRENT_MAP;
		/**
		 * Globale Map fuer die gerade aktive Map
		 */
		public SpriteSetManager SPRITESETMANAGER;
		/**
		 * Globales SPRITESET fuer den aktuellen Helden / Spieler
		 */
		public SpriteSet HERO;
		public GameState STATE;
		/**
		 * Spieler in der Welt
		 */
		public Gee.List<Player> players;
		/* TODO Datum, Zeit, Wetter, ... */

		/**
		 * Konstruktor
		 */
		public World() {
			STATE = new GameState ();
		}
		public void init() {
			//players = new List<Player>();
			/* Globalen TileSetManager erzeugen */
			this.TILESETMANAGER = new HMP.TileSetManager();
			/* Globalen Mapmanager erzeugen */
			this.MAPMANAGER = new HMP.MapManager();
			/* Globalen SpriteSetManager erzeugen */
			this.SPRITESETMANAGER = new HMP.SpriteSetManager();
			//this.SPRITESETMANAGER.printAll();
			this.HERO = SPRITESETMANAGER.getFromName("Hero");
			this.HERO.printAll();
			/* Globle Startmap auswaehlen */
			this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
		}
	}
}
