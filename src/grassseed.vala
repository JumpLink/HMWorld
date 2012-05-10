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
	/**
	 * Klasse fuer Grasssamen.
	 */
	public class GrassSeed : Seed, CircleTool, Tool {
		protected uint applyToTile (LogicalTile l, Tile t, Storage s) {
			if (l.type == TileType.PLANTABLE && seed > 0) {
					l.type = TileType.PLANT;
					l.plant = new Grass ();
					--seed;
					return 1;
			}
			return 0;
		}

		public string toString () {
			return "Grasssamen";
		}

		public uint use (Map m, uint x, uint y, Direction d, Storage s) {
			return applyToLayer (m, x, y, "ground", s);
		}
	}
}