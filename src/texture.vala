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

public class Texture {
	GLuint[] texID;

	void load_from_file() {
		RWops png_dir = new SDL.RWops.from_file("./data/Stadt - Sommer.png", "rb");
		Surface tex = SDLImage.load_png(png_dir);

		if (tex != null)
		{
			glGenTextures(1, out texID);
			glBindTexture(GL_TEXTURE_2D, texID[0]);

			GLvoid[] v = new GLvoid[tex.w*tex.h*4];
			v.insert_vals (0, tex.pixels, tex.w * tex.h * tex.format.BytesPerPixel);

			glTexImage2D(GL_TEXTURE_2D, 0, 3, tex.w, tex.h, 0, GL_BGR, GL_UNSIGNED_BYTE, v);

			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		}
	}
}
