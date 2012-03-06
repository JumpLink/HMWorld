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

const int TIMER_CALLS_PS = 60;
/** Keycode der ESC-Taste */
const int ESC = 27;

const uint EMPTY_TILE = 42;

/** Szenenhintergrundfarbe */
const GL.GLclampf colBG[] = {0.6f, 0.6f, 1.0f, 0.0f};
/** Benamsung der Farbindizes */
enum ColorIndex { R=0, G=1, B=2, A=3 }

enum EdgeShape {
	FULL,
	OUTER_CORNER,
	INNER_CORNER,
	V_LINE,
	H_LINE
}

