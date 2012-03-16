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
using SDL;
using SDLImage;
using HMP;
namespace HMP {
namespace Test {
	class Tester {
		public Tester() {
			print("initialisiere Tester\n");
			int windowID = 0;
			/* Kommandozeile immitieren */
			int argc = 1;
			string[] argv = {"cmd"};

			/* Glut initialisieren */
			glutInit (ref argc, argv);

			/* Initialisieren des Fensters */
			/* RGB-Framewbuffer, Double-Buffering und z-Buffer anfordern */
			glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
			glutInitWindowSize (0, 0);
			glutInitWindowPosition (0, 0);
			
			/* SDL initialisieren */
			if (SDL.init(SDL.InitFlag.EVERYTHING) != 0) {
				print("Unable to initialize SDL: %s\n", SDL.get_error());
				//return true;
			}
			if (SDLImage.init(0) != 0) {
				print("Unable to initialize SDL-Image: %s\n", SDLImage.get_error());
				//return true;
			}
			/* Globalen TileSetManager erzeugen */
			//TILESETMANAGER = new HMP.TileSetManager();
			/* Globalen Mapmanager erzeugen */
			//MAPMANAGER = new HMP.MapManager();
			/* Globle Startmap auswaehlen */
			//MAP = MAPMANAGER.getFromFilename("testmap.tmx");
		}
		
		bool run () {
			print("Beginne mit Tests\n");
			bool error = false;
			var tilesettest = new TileSetTest();
			tilesettest.test_a();
			tilesettest.test_b();
			tilesettest.test_c();
			return error;
		}

		public static int main (string[] args) {
			print("Beginne mit Testprogramm\n");

			Tester tester = new Tester();
			print("Tester erstellt\n");
			return (int) tester.run();
		}
	}
}}
