using GL;
using Gdk;
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

public class Image {
	GLuint* texID = new GLuint[10];

	public void loadFromFile() {
		Pixbuf tex = new Pixbuf.from_file ("./data/Stadt - Sommer.png");

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

		if (tex != null)
		{
			glGenTextures(1, texID);
			glBindTexture(GL_TEXTURE_2D, texID[0]);

			glTexImage2D(GL_TEXTURE_2D, 0, 3, tex.width, tex.height, 0, texture_format, GL_UNSIGNED_BYTE, tex.get_pixels());

			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		}
	}
}
