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

using SDL;
using SDLImage;
using GL;
using Gdk;

public class Texture {
	GLuint* texID = new GLuint[10];

	public void loadFromFile(string path) {
		loadFromFileWithGdk(path);
	}
	
	public void loadFromFileWithGdk(string path) {
		Pixbuf tex;
 		try {
			tex = new Pixbuf.from_file (path);
		}
		catch (GLib.Error e) {
			//GLib.error("", e.message);
			GLib.error("%s konnte nicht geladen werden", path);
		}

		GLenum texture_format;
		
		if(tex.colorspace == Colorspace.RGB)
			if (tex.get_has_alpha())
				texture_format = GL_RGBA;
				//texture_format = GL_BGRA;
			else
				texture_format = GL_RGB;
				//texture_format = GL_BGR;
		else {
			texture_format = 0;
			print("warning: the image is not truecolor..  this will probably break\n");
		}
		bindTexture (texID, tex.width, tex.height, texture_format, tex.get_pixels());
	}
	
	public void loadFromFileWithSdl(string path) {
		RWops png_dir = new SDL.RWops.from_file(path, "rb");
		var tex = SDLImage.load_png(png_dir);

		GLenum texture_format;

		// get the number of channels in the SDL surface
		switch (tex.format.BytesPerPixel) {
			case 4:	// with alpha channel
				    if (tex.format.Rmask == 0x000000ff)
				            texture_format = GL_RGBA;
				    else
				            texture_format = GL_BGRA;
			break;
			case 3:     // no alpha channel
				    if (tex.format.Rmask == 0x000000ff)
				            texture_format = GL_RGB;
				    else
				            texture_format = GL_BGR;
			break;
			default:
				texture_format = 0;
			    print("warning: the image is not truecolor..  this will probably break\n");
			    // this error should not go unhandled
			break;
		}

		bindTexture (texID, tex.w, tex.h, texture_format, tex.pixels);
	}

	public void bindTexture (GL.GLuint* texID, GL.GLsizei width, GL.GLsizei height, GLenum texture_format, void* pixels) {
		if (width > 0 && height > 0)
		{
			glGenTextures(1, texID);
			glBindTexture(GL_TEXTURE_2D, texID[0]);

			glTexImage2D(GL_TEXTURE_2D, 0, 3, width, height, 0, texture_format, GL_UNSIGNED_BYTE, pixels);

			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		}
	}
}
