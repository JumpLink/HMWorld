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
	 * Klasse fuer ein Huhn.
	 */
	public class Chicken : Carryable {

		private static uint FOOD_REQUIREMENT = 3;

		public uint daysWithoutFood = FOOD_REQUIREMENT;

		public override void age () {
			bool food = false;
			//Essen suchen
			foreach (Entity e in WORLD.CURRENT_MAP.entities) {
				HayBale hb = e as HayBale;
				if (!food && daysWithoutFood > 0 && hb != null && !hb.reserved) {
					hb.reserved = true;
					food = true;
				}
			}
			if (!food)
				daysWithoutFood = FOOD_REQUIREMENT;
			//Ei legen
			if (daysWithoutFood == 0) {
				int x = (direction == Direction.NORTH) ? -1 : (direction == Direction.SOUTH) ? 1 : 0;
				int y = (direction == Direction.WEST) ? -1 : (direction == Direction.EAST) ? 1 : 0;
				Egg e = new Egg (pos.x + x, pos.y + y);
				WORLD.CURRENT_MAP.entities.add(e);
			}
		}
	}
}