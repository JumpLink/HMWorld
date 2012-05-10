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
	 * Klasse fuer ein Datum.
	 */
	public class Date {
		/**
		 * Jahreszeit.
		 */
		public Season season = Season.SPRING;
		/**
		 * Tag.
		 */
		public uint day = 1;
		/**
		 * Stunde.
		 */
		public uint hour = DAWN;
		/**
		 * Timer.
		 */
		private double timer = 0;
		/**
		 * Laenge eines Tages (in Sekunden).
		 */
		private double hourLength = 30;
		/**
		 * Laesst das Datum um einen Tag voranschreiten.
		 */
		public void age () {
			if (day < DAYS_PER_SEASON)
				++day;
			else {
				day = 1;
				season = (season + 1) % 4;
			}
			hour = DAWN;
		}
		/**
		 * Laesst die Uhrzeit voranschreiten.
		 */
		public void time () {
			if (hour < DUSK) {
				timer += STATE.interval;
				if (timer / hourLength >= 1) {
					++hour;
					print ("Es ist %u Uhr!\n", hour);
					timer = 0;
				}
			}
		}
	}
}