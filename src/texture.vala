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

//using SDL;
//using SDLImage;
using GL;
using Gdk;
using GLib;

public class Texture {
	GLuint* texID = new GLuint[10];
	GLenum texture_format;
	Gdk.Pixbuf pixbuf;

	public void loadFromFile(string path) {
		loadFromFileWithGdk(path);
	}
	
	public void loadFromFileWithGdk(string path) {
 		try {
			pixbuf = new Pixbuf.from_file (path);
		}
		catch (GLib.Error e) {
			//GLib.error("", e.message);
			GLib.error("%s konnte nicht geladen werden", path);
		}
		
		if(pixbuf.colorspace == Colorspace.RGB)
			if (pixbuf.get_has_alpha()) {
				texture_format = GL_RGBA;
				//texture_format = GL_BGRA;
			}
			else {
				texture_format = GL_RGB;
				//texture_format = GL_BGR;
			}
		else {
			texture_format = 0;
			print("warning: the image is not truecolor..  this will probably break\n");
		}
	}

	public void bindTexture () {
		if (get_width() > 0 && get_height() > 0)
		{
			glGenTextures(1, texID);
			glBindTexture(GL_TEXTURE_2D, texID[0]);

			glTexImage2D(GL_TEXTURE_2D, 0, 3, (GL.GLsizei) get_width(), (GL.GLsizei) get_height(), 0, texture_format, GL_UNSIGNED_BYTE, get_pixels());

			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		}
	}

	public uint get_width() {
		return this.pixbuf.get_width();
	}

	public uint get_height() {
		return this.pixbuf.get_height();
	}

	public void* get_pixels() {
		return this.pixbuf.get_pixels();
	}

	public bool has_alpha() {
		return this.pixbuf.get_has_alpha();
	}

	public Colorspace get_colorspace() {
		return this.pixbuf.get_colorspace();
	}

	public Pixbuf get_Pixbuf() {
		return this.pixbuf;
	}

	public Pixbuf[,] createSplits(int split_width, int split_height, int count_y, int count_x) {
		Pixbuf[,] splits = new Pixbuf[count_y,count_x];
		for(int y = 0; y < count_y; y++) {
			for(int x = 0; x < count_x; x++) {
				pixbuf.copy_area(split_width*count_y, split_height*count_x, split_width, split_height, splits[y,x], 0, 0);
			}
		}
		return splits;
	}
}
