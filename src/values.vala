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
		NORTH=0,
		/**
		 * Oestliche (echts) Richtung.
		 */
		EAST=1,
		/**
		 * Suedliche (unten) Richtung.
		 */
		SOUTH=2,
		/**
		 * Westliche (links) Richtung.
		 */
		WEST=3
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
		/**
		 * SpriteLayerTypes fuer SpriteLayer, beschreibt die Art des Layers.
		 */
	public enum SpriteLayerType {
		/**
		 * Basistyp, die Grundlage eines Sprites
		 */
		BASE,
		/**
		 * Itemtyp, Erweiterungen des Sprites, z.B. Klamotten.
		 */
		ITEM
	}
	public class AnimationData {
		public int x;
		public int y;
		public Mirror mirror;
	}
	public enum Mirror {
		NONE,
		VERTICAL,
		HORIZONTAL
	}
	class Value{
		public Value() {

		}
		public static Direction DirectionParse (string str) {
			switch (str) {
				case "north":
					return HMP.Direction.NORTH;
				case "east":
					return HMP.Direction.EAST;
				case "west":
					return HMP.Direction.WEST;
				case "south":
					return HMP.Direction.SOUTH;
				default:
					return HMP.Direction.NORTH;
			}
		}
		public static string DirectionTo_string (HMP.Direction d) {
			switch (d) {
				case HMP.Direction.NORTH:
					return "NORTH";
				case HMP.Direction.EAST:
					return "EAST";
				case HMP.Direction.WEST:
					return "WEST";
				case HMP.Direction.SOUTH:
					return "SOUTH";
				default:
					return "Unbekannt";
			}
		}
		public static Mirror MirrorParse (string str) {
			switch (str) {
				case "vertical":
					return HMP.Mirror.VERTICAL;
				case "horizontal":
					return HMP.Mirror.HORIZONTAL;
				case "none":
				default:
					return HMP.Mirror.NONE;
			}
		}
		public static SpriteLayerType SpriteLayerTypeParse (string str) {
			switch (str) {
				case "item":
					return HMP.SpriteLayerType.ITEM;
				case "base":
				default:
					return HMP.SpriteLayerType.BASE;
			}
		}
	}
}