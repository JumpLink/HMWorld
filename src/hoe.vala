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
	 * Klasse fuer eine Hacke.
	 */
	public class Hoe : SingleTool, Tool, Object {

		public uint use (Map m, uint x, uint y, Direction d, Storage s) {
			print ("Grabe Boden um an Position (%u, %u)\n", x, y);
			LogicalTile t = logicalTarget (m, x, y, d);
			if (t == null)
				print ("Kein Tile gefunden: %u, %u!\n", x, y);
			if (t.type == TileType.EMPTY_TILE || t.type == TileType.GRASS){
				t.type = TileType.PLANTABLE;
				print ("Boden umgegraben!\n");
				return 1;
			} else {
				print ("Boden konnte nicht umgegraben werden!\n");
			}
			return 0;
		}

		public string toString () {
			return "Hacke";
		}
	}
}