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
	 * Klasse fuer einen Kartenuebergang.
	 */
	public class MapTransition : EventLocation {
		/**
		 * Karte, zu der gewechselt wird.
		 */
		private Map map;

		/**
		 * Konstruktor.
		 * @param m Die Karte.
		 */
		public MapTransition (Map m) {
			map = m;
		}

		public override void trigger (Player p) {
			map.entities.add (p);
			WORLD.CURRENT_MAP.entities.remove_at (WORLD.CURRENT_MAP.entities.index_of(p));
			WORLD.CURRENT_MAP = map;
		}
	}
}