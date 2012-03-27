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
	 * Klasse fuer ein Werkzeug, das nur auf ein Tile wirkt.
	 */
	public interface SingleTool : Tool {

		protected Tile Target (Map m, uint x, uint y, Direction d, string layerName) {
			Layer l = m.getLayerFromName(layerName);
			uint tx = x, ty = y;
			switch (d) {
				case Direction.NORTH:
					ty = y - 1;
					break;
				case Direction.EAST:
					tx = x + 1;
					break;
				case Direction.SOUTH:
					ty = y + 1;
					break;
				case Direction.WEST:
					tx = x - 1;
					break;
			}
			return l.tiles[tx,ty];
		}
	}
}