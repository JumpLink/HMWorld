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
 */
using HMP;
namespace HMP {
	/**
	 * Klasse fuer Spielzustand.
	 */
	public class GameState {
		/**
		 * Pause an oder aus
		 */
		public bool paused = false;
		/**
		 * Debug-Mode on or off
		 */
		public bool debug = false;
		/**
		 * Seit dem letzten Intervall vergangene Zeit in Sekunden
		 */
		public double interval;
		/**
		 * Dialog-Modus ist aktiv.
		 */
		public bool dialog = false;

		public void toggle_paused() {
			paused = toggle (paused);
		}
		public void toggle_debug() {
			debug = toggle (debug);
		}
	}
}