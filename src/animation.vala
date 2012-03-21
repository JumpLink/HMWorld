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
	 * Allgemeine Klasse fuer Sprites
	 */
	public class Animation {
		string name;
		Direction direction;
		bool repeat;
		Gee.List<AnimationData> animationdata = new Gee.ArrayList<AnimationData>();

		public Animation(string name, bool repeat, Direction direction, Gee.List<AnimationData> animationdata) {
			this.name = name;
			this.animationdata = animationdata;
			this.repeat = repeat;
			this.direction = direction;

		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printAnimationData() {
			print("SpriteSetAnimationData\n");
			int count = 0;
			foreach (AnimationData ad in animationdata) {
				print("# %i y: %i x: %i mirror: %s\n", count, ad.x, ad.y, Value.MirrorTo_string(ad.mirror));
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printValues() {
			print("SpriteSetAnimationValues\n");
			print("name: %s\n", name);
			print("direction: %s\n", HMP.Value.DirectionTo_string(direction));
			print("repeat: %s\n", repeat.to_string());
		}
		/**
		 * Gibt alles des SpriteSets auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printAnimationData();
		}
	}
}