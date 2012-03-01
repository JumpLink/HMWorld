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

class Game {
	//public signal void exit();
	
	bool mainloop () {
		return IO.initAndStart ("Titel", 640, 480);
	}

	public static int main (string[] args) {
		//nur um sdl zu testen
		SDL.RWops png_dir = new SDL.RWops.from_file("./data/Stadt - Sommer.png", "rb");
		SDL.Surface png = SDLImage.load_png(png_dir);
		
		Game run = new Game();
		return (int) run.mainloop();;
	}
}
