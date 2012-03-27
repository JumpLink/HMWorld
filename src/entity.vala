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
		 * Geschwindigkeit (Schritte in X-Richtung pro Sekunde)
		 */
		public double steps_ps = 35;
		//private double interval_sum;
		/**
		 * Position des Entities
		 */
		public Coord pos {get; protected set;}
		/**
		 * Karte, auf der sich die Entitaet befindet.
		 */
		public Map map = WORLD.CURRENT_MAP;

		/**
		 * Ausrichtung der Entitaet.
		 */
		public Direction direction = Direction.SOUTH;

		public bool motion { get; protected set; default = false;}

		/**
		 * Konstruktor
		 */
		public Entity() {
			pos = new Coord();
		}
		/**
		 * SpriteSet der Entity, beinhaltet Animationen und deren Grafiken.
		 */
		public SpriteSet spriteset;

		public void setMotion (Direction d, bool motion) {
			//Pruefen ob dies eine veraenderung bewirkt, wenn ja..
			if(direction != d || this.motion != motion) {
				this.motion = motion;
				direction = d;
				spriteset.set_Animation(motion ? "go" : "stay", d);
			}
		}
		/**
		 * Gibt an, ob sich eine Entitaet auf der aktuellen Map kollisonsfrei bewegen kann.
		 */
		private bool motionPossible () {
			int y = (direction == Direction.NORTH) ? -1 : (direction == Direction.SOUTH) ? 1 : 0;
			int x = (direction == Direction.WEST) ? -1 : (direction == Direction.EAST) ? 1 : 0;
			//print ("Spielerposition: %f, %f\n", (pos.x + spriteset.spritewidth/2)/WORLD.CURRENT_MAP.tilewidth, (pos.y + spriteset.spriteheight/2)/WORLD.CURRENT_MAP.tileheight);
			return WORLD.CURRENT_MAP.walkable ((uint) ((pos.x + spriteset.spritewidth/2)/WORLD.CURRENT_MAP.tilewidth + x), 
				(uint) ((pos.y + spriteset.spriteheight/2) /WORLD.CURRENT_MAP.tileheight + y));
		}
		/**
		 * Bewegt die Entitaet zeitabhaengig.
		 * @param interval Zeitraum
		 */
		public void move () {
			if (motion && motionPossible()) {
				switch (direction) {
					case Direction.NORTH:
						pos.y-=WORLD.STATE.interval*steps_ps;
						break;
					case Direction.EAST:
						pos.x+=WORLD.STATE.interval*steps_ps;
						break;
					case Direction.SOUTH:
						pos.y+=WORLD.STATE.interval*steps_ps;
						break;
					case Direction.WEST:
						pos.x-=WORLD.STATE.interval*steps_ps;
						break;
				}
				//Coord min = new Coord();
				//Coord max = new Coord();
				//max.y = map.width;
				//max.x = map.height;
				//pos.crop (min, max);
			}
		}

		/**
		 * Interaktion mit Spieler.
		 * @param p Der Spieler.
		 */
		public abstract void interactWith (Player p);

		public void timer () {
			//print(@"\tinterval $interval");
			move();
			spriteset.time();
		}

		/**
		 * Altert eine Entitaet um einen Tag.
		 */
		public virtual void age () {
			//default: nichts passiert.
		}
		public void draw(double x, double y, double zoff) {
			spriteset.draw(pos.x + x, pos.y + y, zoff);
		}
	}
}