/* Copyright (C) 2012  Pascal Garber
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 */
using HMP;
namespace HMP {
	public abstract class View {
		/**
		 * Perspektivischer Modus, an oder aus
		 */
		public virtual bool perspective { get; protected set; }
		/**
		 * Fensterbreite.
		 */
		public virtual int window_width { get; protected set; }
		/**
		 * Fensterhoehe.
		 */
		public virtual int window_height { get; protected set; }
		public abstract bool init (string[] args, string title, int width, int height);
		public abstract void show();
		public abstract void timer(int lastCallTime);
		public abstract void reshape (int w, int h);
		public abstract void toggle_perspective ();
		/**
		 * Zeichen-Callback.
		 * Loescht die Buffer, ruft das Zeichnen der Szene auf und tauscht den Front-
		 * und Backbuffer.
		 */
		protected static void draw () {
			/* Welt zeichen */
			drawWorld(WORLD);
		}
		protected static void drawWorld(HMP.World world)
		requires (WORLD.CURRENT_MAP != null)
		{
			/* map zeichen */
			drawMap(WORLD.CURRENT_MAP);
		}
		protected static  void drawMap(HMP.Map map)
		requires (map != null)
		requires (map.layers_same != null)
		requires (map.layers_under != null)
		requires (map.layers_over != null)
		requires (map.layers_same[0] != null)
		requires (map.layers_under[0] != null)
		requires (map.layers_over[0] != null)
		requires (map.entities != null)
		requires (map.entities[0] != null)
		{
			//print("==DrawMap==\n");
			foreach (Layer l in map.layers_over) {
				drawLayer(l, 0, 0);
			}
			foreach (Layer l in map.layers_same) {
				drawLayer(l, 0, 0);
			}
			foreach (Entity e in map.entities) {
				drawEntity(e, 0, 0, 0);
			}
			foreach (Layer l in map.layers_under) {
				drawLayer(l, 0, 0);
			}
			for (uint x = 0; x < map.width; ++x)
				for (uint y = 0; y < map.height; ++y) {
					LogicalTile t = map.tiles[x,y];
					if (t != null && t.type == TileType.PLANT && t.plant != null)
						drawSpriteSet(t.plant.spriteset, x * WORLD.CURRENT_MAP.tilewidth, y * WORLD.CURRENT_MAP.tileheight, 0/*zoff*/);
				}
		}
		/**
		 * Die draw-Methode fuer die Layer-Klasse durchlaeuft seine enthaltenen Tiles und ruft jeweils ihre eigene draw-Methode
		 * mit ihren entsprechenden Koordinaten auf und Zeichnet somit das komplette Layer.
		 * @param shift_x Verschiebung in X-Richtung. wird verwendet um die Layerposition im Bildschirm zu bestimmen,
		 * sie wird meistens dazu verwendet den Layer innerhalb des Fensters mittig zu verschieben.
		 * @param shift_y wie shift_x nur in y-Richtung.
		 * @see HMP.Map.draw
		 * @see HMP.Tile.draw
		 */
		protected static void drawLayer(HMP.Layer layer, int shift_x, int shift_y) {
			//print("draw layer\n");
			for (int y=0;y<layer.height;y++) {
				for (int x=0;x<layer.width;x++) {
					if(layer.tiles[x,y].type != TileType.NO_TILE) {
						//print("x: %i y: %i\n", x,y);
						//tiles[x,y].printValues();
						drawTile(layer.tiles[x,y], shift_x + x * layer.tiles[x,y].width, shift_y + y * layer.tiles[x,y].height, layer.zoff);
					}
				}
			}
		}
		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 * @param zoff Angabe der hoehe des Tiles Z.B unter, ueber, gleich, .. dem Held.
		 */
		protected static void drawTile(HMP.Tile tile, double x, double y, double zoff) {
			if (tile.type != TileType.NO_TILE)
				tile.tex.draw((int)x,(int)y,zoff);
		}
		protected static void drawEntity(HMP.Entity e, double x, double y, double zoff) {
			drawSpriteSet(e.spriteset, e.pos.x + x, e.pos.y + y, zoff);
		}
		protected static void drawSpriteSet(HMP.SpriteSet ss, double x, double y, double zoff)
		requires (ss.current_animation != null)
		{
			AnimationData ani = ss.current_animation.get_AnimationData();
			double layer_zoff;
			foreach (SpriteLayer sl in ss.spritelayers) {
				if (sl.active) {
					/* zoff des Layers wird als Kommawert zum zoff dazu addiert*/
					layer_zoff = zoff; // - (sl.number / 100);
					drawSprite(sl.sprites[(uint) ani.coord.y, (uint) ani.coord.x], x, y, zoff, ani.mirror);
				}
			}
		}
		/**
		 * 
		 */
		protected static void drawSprite(HMP.Sprite s, double x, double y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
			s.tex.draw (Round(x-s.width/2),Round(y-s.height/2),zoff,mirror);
		}
	}
}