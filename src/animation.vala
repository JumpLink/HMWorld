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
		public string name;
		public Direction direction;
		public bool repeat;
		public Gee.List<AnimationData> animationdata = new Gee.ArrayList<AnimationData>();

		private int _current_frame_index = 0;
		public int current_frame_index {
			get { return _current_frame_index; }
			set {
				if(animationdata == null || value >= animationdata.size)
					_current_frame_index = 0;
				if (value < 0)
					_current_frame_index = animationdata.size -1;
			}
		}

		public Animation(string name, bool repeat, Direction direction, Gee.List<AnimationData> animationdata) {
			this.name = name;
			this.animationdata = animationdata;
			this.repeat = repeat;
			this.direction = direction;
		}
		public AnimationData get_AnimationData ()
		requires (animationdata != null)
		requires (animationdata[current_frame_index] != null)
		{
			return animationdata[current_frame_index];
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printAnimationData() {
			print("SpriteSetAnimationData\n");
			int count = 0;
			foreach (AnimationData ad in animationdata) {
				print(@"# $count AniData: $ad \n");
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printValues() {
			print("SpriteSetAnimationValues\n");
			print("name: %s\n", name);
			print("direction: %s\n", direction.to_string());
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