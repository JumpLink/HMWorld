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
	 * Allgemeine Entityklasse.
	 * hiervon erben Spieler, NPCs und andere Dynamische Objekte.
	 */
	public abstract class Entity {
		/**
		 * Position des Entities
		 */
		public Coord pos = new Coord();

		/**
		 * Karte, auf der sich die Entitaet befindet.
		 */
		public Map map;

		/**
		 * Ausrichtung der Entitaet.
		 */
		public Direction direction;

		/**
		 * Konstruktor
		 */
		public Entity() {

		}
		/**
		 * SpriteSet der Entity, beinhaltet Animationen und deren Grafiken.
		 */
		public SpriteSet spriteset;
		/**
		 * Bewegt die Entitaet zeitabhaengig.
		 * @param interval Zeitraum
		 * @param d Bewewgungsrichtung
		 */
		public void move (double interval, Direction d) {
			/* Rotation */
			if (direction != d)
				direction = d;
			/* Bewegung */
			else {
				switch (d) {
					case Direction.NORTH:
						pos.x -= interval;
						break;
					case Direction.EAST:
						pos.y += interval;
						break;
					case Direction.SOUTH:
						pos.x += interval;
						break;
					case Direction.WEST:
						pos.y -= interval;
						break;
				}
				Coord min = new Coord();
				Coord max = new Coord();
				max.y = map.width;
				max.x = map.height;
				pos.crop (min, max);
			}
		}

		/**
		 * Interaktion mit Spieler.
		 * @param p Der Spieler.
		 */
		public abstract void interactWith (Player p);
	}
}