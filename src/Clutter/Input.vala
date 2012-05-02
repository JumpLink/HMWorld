/* Copyright (C) 2012  Pascal Garber
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 */

using GL;
using GLU;
using GLUT;
using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer Ein-/Ausgabe-Verarbeitung.
	 * http://references.valadoc.org/#!api=clutter-1.0/Clutter.KeyEvent
	 * http://references.valadoc.org/#!api=clutter-1.0/Clutter.Actor.key_release_event
	 * http://gitorious.org/lethal-works/rubik/blobs/master/rubik.vala#line688
	 */
	class ClutterInput : Input {
		/**
		 * Konstruktor.
		 */
		public ClutterInput() {
		}
		public override void init() {
		}
		public bool on_key_press_event ( Clutter.KeyEvent event )
		{
			Player p = WORLD.PLAYERS.first ();

			if (STATE.dialog) {
				if (event.keyval == UP || event.keyval == DOWN)
					p.chooseAnswer (event.keyval == DOWN);
			} else {
				if (event.keyval == UP)
					p.setMotion (Direction.NORTH, true);
				if (event.keyval == LEFT)
					p.setMotion (Direction.WEST, true);
				if (event.keyval == DOWN)
					p.setMotion (Direction.SOUTH, true);
				if (event.keyval == RIGHT)
					p.setMotion (Direction.EAST, true);
			}
			if (event.keyval == ACTION)
				p.interact();
			if (event.keyval == USE)
				p.use ();
			if (event.keyval == SWAP)
				p.swap ();
			switch (event.keyval) {
				/* Programm beenden */
				case 65307: //ESC
					//cleanupLogic();
					GLib.Process.exit(0);
				case 'p': /*Paused-Mode On/Off*/
				case 'P':
					STATE.toggle_paused();
					VIEW.timer(0);
					print(@"Pause: $(STATE.paused)");
					break;
				case 'b': /*Debug-Mode On/Off*/
				case 'B':
					STATE.toggle_debug();
					print(@"Debug: $(STATE.debug)");
					break;
				case 'v': /*Debug-Mode On/Off*/
				case 'V':
					VIEW.toggle_perspective();
					break;
			}
			return true;
		}
		public bool on_key_release_event ( Clutter.KeyEvent event )
		{
			Player p = WORLD.PLAYERS.first ();
			if (event.keyval == UP) {
				if (p.direction == Direction.NORTH)
					p.setMotion (Direction.NORTH, false);
			}
			if (event.keyval == LEFT) {
				if (p.direction == Direction.WEST)
					p.setMotion (Direction.WEST, false);
			}
			if (event.keyval == DOWN) {
				if (p.direction == Direction.SOUTH)
					p.setMotion (Direction.SOUTH, false);
			}
			if (event.keyval == RIGHT) {
				if (p.direction == Direction.EAST)
					p.setMotion (Direction.EAST, false);
			}
			return true;
		}
		public void registerCallbacks (Clutter.Stage stage)
		{
			stage.key_press_event.connect (on_key_press_event);
			stage.key_release_event.connect (on_key_release_event);
		}
	}
}