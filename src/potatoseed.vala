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
	 * Klasse fuer Kartoffeln zum sähen.
	 */
	public class PotatoSeed : Seed, Tool, CircleTool {

		public PotatoSeed () {
			seed = SEED_PER_BAG;
		}

		public string toString () {
			return "Kartoffelsack";
		}

		public uint use (Map m, uint x, uint y, Direction d, Storage s) {
			print ("Pflanze Kartoffeln an %u, %u!\n", x, y);
			return applyToLayer (m, x, y, "same as hero 2", s);
		}

		protected uint applyToTile (LogicalTile l, Tile t, Storage s) {
			if (l.type == TileType.PLANTABLE && l.plant == null && seed > 0) {
				l.plant = new Potato ();
				l.type = TileType.PLANT;
				--seed;
				print ("Kartoffel gepflanzt!\n");
				return 1;
			} else {
				print ("Keine Kartoffel gepflanzt!\n");
			}
			return 0;
		}
	}
}