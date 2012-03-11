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
/**
 * Klasse fuer Maps
 */
public class Map {

	class XML : HMPXML {
		string path;
		Xml.Doc* doc;
		Context ctx;

		public XML(string path) {
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

		public Gee.List<Layer> loadLayer () {
			Xml.Node* node = evalExpression("/map");
			Gee.List<Layer> layer = new Gee.ArrayList<Layer>();
			//loadProperties(node);
			return layer;


		}

	    protected Gee.HashMap<string, string> loadProperties(Xml.Node* node) {
	        Xml.Attr* attr = null;
	        attr = node->properties;
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
	            print("Found the node we want");
	        } else {
	            print("failed to find the expected node");
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
	public string source;
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
	 * Konstruktor
	 */
	public Map(string path, string filename) {
		layers = new Gee.ArrayList<Layer>();
		entities = new Gee.ArrayList<Entity>();
		tileset = new Gee.ArrayList<TileSetMapData?>();
		source = filename;
		XML xml = new XML(path);
		xml.loadGlobalMapProperties(out orientation, out version, out width, out height, out tilewidth, out tileheight);
		xml.loadLayer();
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

	public static Vector tileNumberToVektor(uint number, uint width, uint height) {
		Vector vector = new Vector(2);
		return vector;
	}
	/**
	 * Gibt alle Werte der Map auf der Konsole aus
	 */
	public void printValues() {
		print("source: %s\n", source);
		print("orientation: %s\n", orientation);
		print("version: %s\n", version);
		print("width: %u\n", width);
		print("height: %u\n", height);
		print("tilewidth: %u\n", tilewidth);
		print("tileheight: %u\n", tileheight);
	}
}
