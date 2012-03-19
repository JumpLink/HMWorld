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
	const GL.GLclampf colBG[] = {0.0f, 0.0f, 0.0f, 0.0f};
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
	/**
	 * TODO Ole
	 */
	enum EdgeShape {
		FULL,
		OUTER_CORNER,
		INNER_CORNER,
		V_LINE,
		H_LINE
	}
	/**
	 * TODO Ole
	 */
	public enum Direction {
		/**
		 * Noerdliche (oben) Richtung.
		 */
		NORTH,
		/**
		 * Oestliche (echts) Richtung.
		 */
		EAST,
		/**
		 * Suedliche (unten) Richtung.
		 */
		SOUTH,
		/**
		 * Westliche (links) Richtung.
		 */
		WEST
	}
	/**
	 * TODO Ole
	 */
	public enum CropType {
		/**
		 * TODO Ole
		 */
		EMPTY_CROP,
		/**
		 * TODO Ole
		 */
		GRASS,
		/**
		 * TODO Ole
		 */
		POTATO
	}
	/**
	 * TODO Ole
	 */
	public enum TileType {
		/**
		 * TileTyp fuer Tiles die nicht gezeichnet werden, bzw. gar nicht existieren.
		 */
		NO_TILE,
		/**
		 * TODO Ole
		 */
		EMPTY_TILE,
		/**
		 * TODO Ole
		 */
		PLANTABLE,
		/**
		 * TODO Ole
		 */
		PLANT,
		/**
		 * TODO Ole
		 */
		GRASS,
		/**
		 * TODO Ole
		 */
		PATH,
		/**
		 * TODO Ole
		 */
		BUILDING,
		/**
		 * TODO Ole
		 */
		ROCK,
		/**
		 * TODO Ole
		 */
		WOOD,
		/**
		 * TODO Ole
		 */
		WATER
	}
}