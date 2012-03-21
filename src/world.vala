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
		public GameState STATE;
		/**
		 * Entitaeten in der Welt
		 */
		public Gee.List<Player> PLAYERS = new Gee.ArrayList<Player>();
		/* TODO Datum, Zeit, Wetter, ... */

		/**
		 * Konstruktor
		 */
		public World() {
			STATE = new GameState ();
		}
		public void init() {
			/* Globalen TileSetManager erzeugen */
			this.TILESETMANAGER = new HMP.TileSetManager();
			/* Globalen Mapmanager erzeugen */
			this.MAPMANAGER = new HMP.MapManager();
			/* Globalen SpriteSetManager erzeugen */
			this.SPRITESETMANAGER = new HMP.SpriteSetManager();
			//this.SPRITESETMANAGER.printAll();
			PLAYERS.add (new Player("Hero", SPRITESETMANAGER.getFromName("Hero")));
			PLAYERS[0].printAll();
			/* Globle Startmap auswaehlen */
			this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
		}
		public void draw() {
			/* map zeichen */
			CURRENT_MAP.draw();
		}

		public void timer (double interval) {
			foreach (Player p in PLAYERS)
				p.timer(interval);
		}
	}
}
