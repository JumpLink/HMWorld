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
using HMP;
namespace HMP {
	HMP.World WORLD;
	HMP.View VIEW;
	HMP.Input INPUT;
	HMP.GameState STATE;
	HMP.ViewEngine VIEWENGINE = HMP.ViewEngine.GTK_CLUTTER; //Díes kann bisher nur in HMP.ViewEngine.CLUTTER, HMP.ViewEngine.GTK_CLUTTER oder HMP.ViewEngine.OPENGL geändert werden.
	HMP.GdkTextureFactory TEXTUREFACTORY;
	class Game {
		public Game() {
			
		}
		public static int main (string[] args) {
			string[] sim_args = new string[1];
			sim_args[0] = args[0];
			switch (args[1]){
				case "-o":
				case "--opengl":
					VIEWENGINE = HMP.ViewEngine.OPENGL;
				break;
				case "-c":
				case "--clutter":
					VIEWENGINE = HMP.ViewEngine.CLUTTER;
				break;
				default:
					print(@"$(args[0])\nYou must set a ViewEngine\n");
					GLib.Process.exit(0);
			}	
			TEXTUREFACTORY = new GdkTextureFactory(VIEWENGINE);
			WORLD = new World ();
			STATE = new GameState();
			switch (VIEWENGINE) {
				case HMP.ViewEngine.OPENGL:
					VIEW = new OpenGLView();
					INPUT = new OpenGLInput();
					break;
				case HMP.ViewEngine.SDL:
					break;	
				case HMP.ViewEngine.CLUTTER:
					VIEW = new ClutterView();
					//INPUT wird innerhalb der ClutterView gesetzt 
					break;
			}
			VIEW.init (sim_args, "Titel", 640, 480);
			WORLD.init();
			INPUT.init();
			VIEW.show();
			
			return 1;
		}
	}
}
