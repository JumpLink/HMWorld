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
	 * Klasse fuer ein Werkzeug, das auf alle Tiles im unmittelbaren Umkreis des Spielers wirkt.
	 */
	public interface CircleTool : Tool {

		/**
		 * Wendet das Werkzeug auf ein Tile an.
		 * @param t Das Tile.
		 * @param s Das Lager.
		 */
		protected abstract void applyToTile (Tile t, Storage s);

		/**
		 * Wendet das Werkzeug auf alle Tiles im unmittelbaren Umkreis des Spielers 
		 * auf einer Ebene an.
		 * @param m Karte, auf der sich der Spieler befindet.
		 * @param x x-Koordinate des Spielers.
		 * @param m y y-Koordinate des Spielers.
		 * @param layerName Name der Ebene.
		 */
		protected void applyToLayer (Map m, uint x, uint y, string layerName, Storage s) {
			Layer l = m.getLayerFromName(layerName);
			for (uint ix = x - 1; ix <= (x + 1); ++ix)
				for (uint iy = y - 1; iy <= (y + 1); ++iy) {
						print ("Bearbeite Tile %u, %u\n", ix, iy);
						applyToTile (l.tiles[ix, iy], s);
						if (l.tiles[ix, iy].plant == null)
							print ("Keine Pflanze!\n");
					}
		}

	}
}