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

		public void use (Map m, uint x, uint y, Direction d, Storage s) {
			print ("Pflanze Kartoffeln an %u, %u!\n", x, y);
			applyToLayer (m, x, y, "same as hero 2", s);
		}

		protected void applyToTile (Tile t, Storage s) {
			if (/*t.type == TileType.PLANTABLE && */t.plant == null && seed > 0) {
				//t.type = TileType.PLANT;
				t.plant = new Potato ();
				t.type = TileType.PLANT;
				//FIXME keine NO_TILE manipulieren, sonst gdk_pixbuf_get_height: assertion
				--seed;
				print ("Kartoffel gepflanzt!\n");
			}
		}
	}
}