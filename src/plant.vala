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
	  * Klasse fuer Pflanzen.
	  */
	 abstract class Plant {
	 	/**
	 	 * Pflanze lebt.
	 	 */
	 	bool alive;
	 	/**
	 	 * Pflanze wurde begossen.
	 	 */
	 	bool watered;
	 	/**
	 	 * Tage, die bis zur naechsten Ernte vergehen muessen.
	 	 */
	 	uint daysUntilHarvest;
	 	/**
	 	 * Pflanze kann noch so oft geerntet werden.
	 	 */
	 	uint cropsLeft;

	 	/**
	 	 * Minimale Zeit zwischen Ernten.
	 	 */
	 	static uint timeBetweenCrops;

	 	/**
	 	 * Maximale Anzahl an Ernten.
	 	 */
	 	static uint maxCrops;

	 	/**
	 	 * Art der Ernte.
	 	 */
	 	static CropType crop;

	 	/**
	 	 * Pflanze wachsen lassen.
	 	 */
	 	void grow () {
	 		if (watered && daysUntilHarvest > 0)
	 			--daysUntilHarvest;
	 		watered = false;
	 	}

	 	/**
	 	 * Pflanze begiessen, sofern sie noch lebt.
	 	 */
	 	void water () {
	 		watered = alive;
	 	}

	 	/**
	 	 * Erntet eine Pflanze.
	 	 * @return Die Ernte.
	 	 */
	 	CropType harvest () {
	 		if (daysUntilHarvest == 0) {
	 			--cropsLeft;
	 			daysUntilHarvest = timeBetweenCrops;
	 			return crop;
	 		}
	 		return CropType.EMPTY_CROP;
	 	}
	 }
}