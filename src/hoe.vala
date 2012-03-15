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
	public class Hoe : SingleTool {

		public override void use (Map m, uint x, uint y, Direction d) {
			Tile t = Target (m, x, y, d, "ground");
			if (t.type == TileType.EMPTY_TILE || t.type == TileType.GRASS)
				t.type = TileType.PLANTABLE;
		}
	}
}