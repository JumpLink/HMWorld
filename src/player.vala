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

		private double interactionRadius = 15.0;

		/**
		 * Konstruktor
		 */
		public Player(string name, SpriteSet spriteset) {
			base ();
			this.name = name;
			this.spriteset = spriteset;
			tools = new Inventory ();
			storage = new Storage ();
			spriteset.set_Animation("stay", Direction.SOUTH	);
		}

		/**
		 * Gibt an, ob sich eine Entitaet in Reichweite des Spielers befindet.
		 * @param e Die Entitaet.
		 * @return Entitaet in Reichweite.
		 */
		private bool inRange(Entity e) {
			Vector v = new Vector.fromDifference (e.pos, pos);
			if (e != this && v.VectorNorm() < interactionRadius) {
				//print ("V: %f, %f\n", v.vec[0], v.vec[1]);
				return (direction == Direction.NORTH && v.vec[0] > 0.0)
					|| (direction == Direction.EAST && v.vec[1] < 0.0)
					|| (direction == Direction.SOUTH && v.vec[0] < 0.0)
					|| (direction == Direction.WEST && v.vec[1] > 0.0);
			}
			return false;
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
			print ("Spieler %s interagiert\n", name);
			foreach (Entity e in WORLD.CURRENT_MAP.entities) {
				if (item == null && inRange(e))
					e.interactWith(this);
			}
		}

		public override void interactWith (Player p) {
			//TODO Interaktion zwischen zwei Spielern.
		}

	}
}
