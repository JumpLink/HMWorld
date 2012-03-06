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
	/*
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

		this.width = tex.w;
		this.height = tex.h;
		bpp = tex.format.BytesPerPixel;
		//this.pixels.set_size(width*height*bpp);
		this.pixbuf = new Pixbuf((Colorspace colorspace, bool has_alpha, int bits_per_sample, int width, int height tex.pixels;
	}*/

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

	public int get_width() {
		return pixbuf.get_width();
	}

	public int get_height() {
		return pixbuf.get_height();
	}

	public void* get_pixels() {
		return pixbuf.get_pixels();
	}
/*
	public Gdk.Pixbuf SDLSurfaceToGdkPixbuf (SDL.Surface s) {

	}*/

	/*
	public SDL.Surface GdkPixbufToSDLSurface (Gdk.Pixbuf p) {
		p.get_pixels(), p.get_width(), p.height(), 8*bpp, get_byte_length ()
		//depth = depth bits per pixel
		// Pitch is the size of the scanline of the surface, in bytes, i.e. widthInPixels*bytesPerPixel.
		return Surface.from_RGB(void* pixels, int width, int height, int depth, int pitch, uint32 rmask, uint32 gmask, uint32 bmask, uint32 amask)
	}*/
}
