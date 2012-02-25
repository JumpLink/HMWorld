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
 
/* To compile this software install the following dependencies on Ubuntu 11.10
 * sudo apt-get install valac freeglut3 freeglut3-dev libxi-dev libxi6 libxmu-dev libxi6 libxmu-dev libxmu6
 *
 * And compile
 * valac --vapidir=../vapi/ --pkg gl --pkg glu --pkg glut -X -lglut main.vala scene.vala values.vala io.vala
 */
 
class Game {
	//public signal void exit();
	
	bool mainloop () {
		bool running = IO.initAndStart ("Titel", 640, 480);

		IO.setProjection((double) 640/480);
		// Main loop
		while (running) {
			IO.registerCallbacks ();
		}

		// Exit program
		return true;
	}

	public static int main (string[] args) {
		Game run = new Game();
		return (int) run.mainloop();;
	}
}
