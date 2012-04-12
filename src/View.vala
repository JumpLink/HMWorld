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
using HMP;
namespace HMP {
	public abstract class View {
		/**
		 * Perspektivischer Modus, an oder aus
		 */
		public static bool perspective = false;
		/**
		 * Fensterbreite.
		 */
		public virtual int window_width { get; protected set; }
		/**
		 * Fensterhoehe.
		 */
		public virtual int window_height { get; protected set; }
		public abstract bool init (string title, int width, int height);
		public abstract void show();
		public virtual void toggle_perspective() {
			perspective = toggle (perspective);
			print(@"Perspektive: $(perspective)");
		}
	}
}
