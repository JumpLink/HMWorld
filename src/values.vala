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
	const int TIMER_CALLS_PS = 60;
	/**
	 * Keycode der ESC-Taste
	 */
	const int ESC = 27;

	/**
	 * Kapazitaet der Giesskanne.
	 */
	const uint WATER_CAPACITY = 10;

	/**
	 * Samen pro Sack.
	 */
	const uint SEED_PER_BAG = 10;

	/**
	 * Szenenhintergrundfarbe
	 */
	const GL.GLclampf colBG[] = {0.6f, 0.6f, 1.0f, 0.0f};
	/**
	 * Benamsung der Farbindizes
	 */
	enum ColorIndex {
		/**
		 * Rot
		 */
		R=0,
		/**
		 * Gruen
		 */
		G=1,
		/**
		 * Blau
		 */
		B=2,
		/**
		 * Alpha
		 */
		A=3 }

	enum EdgeShape {
		FULL,
		OUTER_CORNER,
		INNER_CORNER,
		V_LINE,
		H_LINE
	}

	public enum Direction {
		NORTH,
		EAST,
		SOUTH,
		WEST
	}

	public enum CropType {
		EMPTY_CROP,
		GRASS,
		POTATO
	}

	public enum TileType {
		NO_TILE,
		EMPTY_TILE,
		PLANTABLE,
		PLANT,
		GRASS,
		PATH,
		BUILDING,
		ROCK,
		WOOD,
		WATER
	}
}