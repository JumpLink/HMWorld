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
using Xml;
using Xml.XPath;
using Gee;

namespace HMP {
	/**
	 * Klasse fuer Maps
	 */
	public class Map {

		class XML : HMP.XML {
			string path;
			Xml.Doc* doc;
			Context ctx;

			public XML(string path) {
				print("Erstelle XML-Objekt vom Path %s\n", path);
				Parser.init ();
				this.path = path;
				doc = Parser.parse_file (path);
				if(doc==null) print("failed to read the .xml file\n");
				
				ctx = new Context(doc);
				if(ctx==null) print("failed to create the xpath context\n");
			}

			~XML() {
				delete doc;
				Parser.cleanup ();
			}

			public void loadGlobalMapProperties (out string orientation, out string version, out uint width, out uint height, out uint tilewidth, out uint tileheight) {
				Xml.Node* node = evalExpression("/map");
				Gee.HashMap<string, string> properties = loadProperties(node);

				orientation = (string) properties.get ("orientation");
				version = (string) properties.get ("version");
				width = int.parse(properties.get ("width"));
				height = int.parse(properties.get ("height"));
				tilewidth = int.parse(properties.get ("tilewidth"));
				tileheight = int.parse(properties.get ("tileheight"));
			}

			public Gee.List<Layer> loadLayers () {
				Gee.List<Layer> layer = new Gee.ArrayList<Layer>();
				unowned Xml.XPath.Object obj = ctx.eval_expression("/map/layer");
				if(obj==null) print("failed to evaluate xpath\n");
				for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
					print("i %i\n",i);
					Xml.Node* node = obj.nodesetval->item(i);
					Gee.HashMap<string, string> properties = loadProperties(node);
					string name = (string) properties.get ("name");
					int width = int.parse(properties.get ("width"));
					int height = int.parse(properties.get ("height"));
					int.parse(properties.get ("height"));
					print("Lade Tiles\n");
					Tile[,] tiles = loadTiles(i, width, height);
					print("Fuege Layer mit Namen %s hinzu\n", properties.get ("name"));
					double z;
					loadLayerZ(i, width, height, out z);
					layer.add( new Layer.all( name, z, width, height, tiles));
				}

				return layer;
			}
			private bool loadLayerZ (uint layer_number, uint width, uint height, out double z) {
				Xml.Node* node = evalExpression("/map/layer["+(layer_number+1).to_string()+"]/properties/property");
				Xml.Attr* attr = node->properties;
				Tile[,] tiles = new Tile[width, height];
				string name;
				string content;
				while ( attr != null) {
					name = (string) attr->name;
					content = (string) attr->children->content;
					print("Attribute: \tname: %s\tvalue: %s\n", name, content);
					if (name == "name" && content == "z") {
						print("Z-Wert folgt\n");
						attr = attr->next;
						if (attr != null) {
							name = (string) attr->name;
							content = (string) attr->children->content;
							if (name == "value" ) {
								print("Attribute: \tname: %s\tvalue: %s\n", name, content);
								z = double.parse(content);
								return true;
						}
					}
					} else {
						attr = attr->next;
					}
				}
				return false;
			}

			private Tile[,] loadTiles (uint layer_number, uint width, uint height) {
				Xml.Node* node = evalExpression("/map/layer["+(layer_number+1).to_string()+"]/data");
				Xml.Attr* attr = node->properties;
				Tile[,] tiles = new Tile[width, height];

				while ( attr != null ) {
					print("Attribute: \tname: %s\tvalue: %s, x: %u y: %u\n", attr->name, attr->children->content, layer_number%width, layer_number/width);
					Tile tmp_tile = new RegularTile.fromGid(int.parse(attr->children->content));
					tiles[(int)(layer_number%width),(int)(layer_number/width)] = tmp_tile;
					attr = attr->next;
				}
				return tiles;
			}

			protected Gee.HashMap<string, string> loadProperties(Xml.Node* node) {
				Xml.Attr* attr = node->properties;
				Gee.HashMap<string, string> properties = new Gee.HashMap<string, string>();

				while ( attr != null ) {
					print("Attribute: \tname: %s\tvalue: %s\n", attr->name, attr->children->content);
					properties.set(attr->name, attr->children->content);
					attr = attr->next;
				}
				return properties;
			}

		    protected Xml.Node* evalExpression (string expression ) {
		        unowned Xml.XPath.Object obj = ctx.eval_expression(expression);
		        if(obj==null) print("failed to evaluate xpath\n");

		        Xml.Node* node = null;
		        if ( obj.nodesetval != null && obj.nodesetval->item(0) != null ) {
		            node = obj.nodesetval->item(0);
		            print("Found the node we want\n");
		        } else {
		            print("failed to find the expected node\n");
		        }
		        return node;
		    }
		}

		public struct TileSetMapData {
			/**
			 * Quelle des TileSets.
			 */
			public string source;
			/**
			 * TODO
			 */
			public uint firstgid;
		}
		/**
		 * orientation der Map.
		 */
		public string orientation;
		/**
		 * Version des Kartenformats?
		 */
		public string version;
		/**
		 * Gesamtbreite der map
		 */
		public uint width;
		/**
		 * Gesamthoehe der Map
		 */
		public uint height;
		/**
		 * Breite eines Tiles
		 */
		public uint tilewidth;
		/**
		 * Höhe eines Tiles
		 */
		public uint tileheight;
		/**
		 * Dateiname der Map
		 */
		public string filename;
		/**
		 * Tilesets die für auf der Map verwendet werden
		 */
		public Gee.List<TileSetMapData?> tileset;
		/**
		 * Layer der Map.
		 */
		public Gee.List<Layer> layers;
		/** 
		 * Entities auf der Map
		 */
		public Gee.List<Entity> entities;

		/**
		 * Konstruktor fuer eine leere Map
		 */
		public Map() {
			print("Erstelle leeres Map Objekt\n");
			layers = new Gee.ArrayList<Layer>();
			entities = new Gee.ArrayList<Entity>();
			tileset = new Gee.ArrayList<TileSetMapData?>();
		}
		/**
		 * Konstrukter, ladet Map mit Daten einer Mapdatei
		 *
		 * @param path Das Verzeichnis aus dem gelesen werden soll
		 * @param fn Der Dateiname der gelesen werden soll
		 */
		public Map.fromPath (string path, string fn) {
			print("Lade Mapdateien von %s + %s\n", path, fn);

			this.filename = fn;
			XML xml = new XML(path+filename);
			xml.loadGlobalMapProperties(out orientation, out version, out width, out height, out tilewidth, out tileheight);
			layers = xml.loadLayers();
		}

		public int getIndexOfLayerName(string name) {
			foreach (Layer i in layers) {
				if (name == i.name) {
					return layers.index_of(i);
				}
			}
			return -1;
		}

		public void addLayerTile(string layer_name, uint number, uint value) {
			int index = getIndexOfLayerName(layer_name);
			Layer tmp_layer = layers.get(index);
			//Vector = tileNumberToVektor(number, width, height);
		}
		/**
		 * Gibt alle Werte (bis auf die Layer) der Map auf der Konsole aus
		 */
		public void printValues() {
			print("==MAP==\n");
			print("filename: %s\n", filename);
			print("orientation: %s\n", orientation);
			print("version: %s\n", version);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("tilewidth: %u\n", tilewidth);
			print("tileheight: %u\n", tileheight);
		}
		/**
		 * Gibt die Werte aller Layer der Map auf der Konsole aus
		 */
		public void printLayers() {
			print("====ALL LAYERS FROM MAP %s====\n", filename);
			foreach (HMP.Layer l in layers) {
				l.printValues();
				l.printTiles();
	   		}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printLayers();
		}
	}
}
