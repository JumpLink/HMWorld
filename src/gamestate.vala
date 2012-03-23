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
	 * Klasse fuer Spielzustand.
	 */
	public class GameState {
		/**
		 * Viewport.
		 */
		public int[] VIEWPORT = new int[4];
		/**
		 * Fensterbreite.
		 */
		public int window_width {
			get { return VIEWPORT[2]; }
			set { VIEWPORT[2] = value;}
		}
		/**
		 * Fensterhoehe.
		 */
		public int window_height {
			get { return VIEWPORT[3]; }
			set { VIEWPORT[3] = value;}
		}
		/**
		 * Pause an oder aus
		 */
		public bool paused = false;

		public double interval;
		/**
		 * Konstruktor.
		 */
		public GameState () {

		}
		public void toggle_paused() {
			paused = paused ? false : true;
		}
	}
}