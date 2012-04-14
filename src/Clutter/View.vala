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
	public class ClutterView : View {
		/**
		 * Perspektivischer Modus, an oder aus
		 */
		public override bool perspective { get; protected set; }
		/**
		 * Fensterbreite.
		 */
		public override int window_width { get; protected set; }
		/**
		 * Fensterhoehe.
		 */
		public override int window_height { get; protected set; }
		public override bool init (string title, int width, int height) {
			print("TODO");
			return true;
		}
		public override void show() {
			print("TODO");
		}
		public override void timer(int lastCallTime) {
			print("TODO");
		}
		public override void reshape (int w, int h) {
			print("TODO");
		}
		public override void toggle_perspective () {
			print("TODO");
		}
	}
}
