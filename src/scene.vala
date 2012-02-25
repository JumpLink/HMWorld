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

using GL;
using GLU;
using GLUT;

namespace Scene {
	/**
	 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
	 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
	 * OpenGL-Statusmaschine.
	 * @return Rueckgabewert: im Fehlerfall 0, sonst 1.
	 */
	static bool init ()
	{
		/* Setzen der Farbattribute */
		/* Hintergrundfarbe */
		glClearColor (colBG[ColorIndex.R], colBG[ColorIndex.G], colBG[ColorIndex.B], colBG[ColorIndex.A]);
		/* Zeichenfarbe */
		glColor3f (1.0f, 1.0f, 1.0f);

		/* Vertexarrays erlauben */
		glEnableClientState (GL_VERTEX_ARRAY);

		/* Polygonrueckseiten nicht anzeigen */
		/*glCullFace (GL_BACK);
		glEnable (GL_CULL_FACE);*/

		/* Alles in Ordnung? */
		return (glGetError() == GL_NO_ERROR);
	}
}
