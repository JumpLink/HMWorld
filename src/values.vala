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
		WEST=3;

		public string to_string () {
			switch (this) {
				case HMP.Direction.NORTH:
					return "north";
				case HMP.Direction.EAST:
					return "east";
				case HMP.Direction.WEST:
					return "west";
				case HMP.Direction.SOUTH:
					return "south";
				default:
					assert_not_reached();
			}
		}
		public static Direction parse (string str) {
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
					assert_not_reached();
			}
		}
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
		BASE=0,
		/**
		 * Itemtyp, Erweiterungen des Sprites, z.B. Klamotten.
		 */
		ITEM=1;

		public static SpriteLayerType parse (string str) {
			switch (str) {
				case "item":
					return HMP.SpriteLayerType.ITEM;
				case "base":
				default:
					return HMP.SpriteLayerType.BASE;
			}
		}
	}
	public class Coord:Vector {
		public Coord() {
			base(2);
		}
		public Coord.nondefault (double x, double y) {
			this();
			this.x = x;
			this.y = y;
		}
		public double x {
			get { return vec[1]; }
			set { vec[1] = value; }
		}
		public double y {
			get { return vec[0]; }
			set { vec[0] = value; }
		}
	}	
	public class AnimationData {
		public Coord coord { public get; private set; }
		public AnimationData () {
 			coord = new Coord();
		}
		public Mirror mirror;
		public double x {
			get { return coord.x; }
			set { coord.x = value; }
		}
		public double y {
			get { return coord.y; }
			set { coord.y = value; }
		}

		public string to_string () {
			return @"x: $x y: $y mirror: $mirror";
		}
	}

	public enum Mirror {
		NONE,
		VERTICAL,
		HORIZONTAL;

		public string to_string () {
			switch (this) {
				case HMP.Mirror.VERTICAL:
					return "vertical";
				case  HMP.Mirror.HORIZONTAL:
					return "horizontal";
				case HMP.Mirror.NONE:
					return "none";
				default:
					assert_not_reached();
			}
		}

		public static Mirror parse (string str) {
			switch (str) {
				case "vertical":
					return HMP.Mirror.VERTICAL;
				case "horizontal":
					return HMP.Mirror.HORIZONTAL;
				case "none":
					return HMP.Mirror.NONE;
				default:
					assert_not_reached();
			}
		}
	}
	public enum DrawLayer {
		UNDER = 1,
		SAME = 0,
		OVER = -1;

		public static DrawLayer parse (string str) {
			switch (str) {
				case "same":
					return HMP.DrawLayer.SAME;
				case "over":
					return HMP.DrawLayer.OVER;
				case "under":
					return HMP.DrawLayer.UNDER;
				default:
					assert_not_reached();
			}
		}
	}
}