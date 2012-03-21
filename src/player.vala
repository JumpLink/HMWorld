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
	 * Klasse fuer das Spielerobjekt
	 */
	public class Player : Entity {
		/**
		 * Name des Spielers
		 */
		public string name;

		/**
		 * Inventar
		 */
		public Inventory tools;

		/**
		 * Aufgehobener Gegenstand.
		 */
		public Carryable item;

		/**
		 * Lager.
		 */
		public Storage storage;
		SpriteSet spriteset;

		/**
		 * Konstruktor
		 */
		public Player(string name, SpriteSet spriteset) {
			base ();
			this.name = name;
			this.spriteset = spriteset;
			tools = new Inventory ();
			storage = new Storage ();
		}

		/**
		 * Gibt an, ob sich eine Entitaet in Reichweite des Spilers befindet.
		 * @param e Die Entitaet.
		 * @return Entitaet in Reichweite.
		 */
		private bool inRange(Entity e) {
			switch (direction) {
				case Direction.NORTH:
					return ((uint)(pos.vec[0] + 0.5) == (uint)(e.pos.vec[0] + 0.5)) && 
					((uint)(pos.vec[1] + 0.5) - (uint)(e.pos.vec[1] + 0.5) == 1);
				case Direction.EAST:
					return ((uint)(pos.vec[1] + 0.5) == (uint)(e.pos.vec[1] + 0.5)) && 
					((uint)(pos.vec[0] + 0.5) - (uint)(e.pos.vec[0] + 0.5) == -1);
				case Direction.SOUTH:
					return ((uint)(pos.vec[0] + 0.5) == (uint)(e.pos.vec[0] + 0.5)) && 
					((uint)(pos.vec[1] + 0.5) - (uint)(e.pos.vec[1] + 0.5) == -1);
				default:
					return ((uint)(pos.vec[1] + 0.5) == (uint)(e.pos.vec[1] + 0.5)) && 
					((uint)(pos.vec[0] + 0.5) - (uint)(e.pos.vec[0] + 0.5) == 1);
			}
		}

		public void printTools() {
			
		}
		public void printItems() {
			
		}
		public void printSpriteSet() {
			spriteset.printAll();
		}
		public void printValues() {
			print("Name: "+this.name+"\n");
		}
		public void printAll() {
			printValues();
			printSpriteSet();
			printItems();
			printTools();
		}
		/**
	 	 * Benutzt ausgeruestetes Werkzeug mit Spielerumgebung.
	 	 */
		public void use () {
			tools.use (map, ((uint) pos.vec[0]), ((uint) pos.vec[1]), direction, storage);
		}

		/**
		 * Interagiert mit Spielerumgebung (Sachen aufheben, NPCs ansprechen)
		 */
		public void interact () {
			foreach (Entity e in WORLD.CURRENT_MAP.entities) {
				if (inRange(e))
					e.interactWith(this);
			}
		}

		public override void interactWith (Player p) {
			//TODO Interaktion zwischen zwei Spielern.
		}
	}
}
