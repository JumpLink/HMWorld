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
	public class GdkTextureFactory {
		HMP.ViewEngine ve;
		public GdkTextureFactory(HMP.ViewEngine ve) {
			this.ve = ve;
		}
		public HMP.GdkTexture empty () {
			switch (ve) {
				case HMP.ViewEngine.OPENGL:
					return new OpenGLTexture();
				case HMP.ViewEngine.SDL:
					assert_not_reached(); //TODO
				case HMP.ViewEngine.CLUTTER:
					//return new ClutterTexture();
					return new OpenGLTexture();
				case HMP.ViewEngine.GTK_CLUTTER:
					//return new GtkClutterTexture();
					return new OpenGLTexture();
				default:
					assert_not_reached();
			}
		}
		public HMP.GdkTexture fromPixbuf(Gdk.Pixbuf pixbuf) {
			HMP.GdkTexture tex = this.empty();
			tex.loadFromPixbuf(pixbuf);
			return tex;
		}
	}
}