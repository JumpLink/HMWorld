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
using Gee;
/**
 * Klasse fuer Maps
 */
public class Map {

	/**
	 * Klasse fuer XML-Operationen
	 */
	class XML : HMPXML {

		/** Daten der Map. */
		protected Data data = Data();

		/**
		 * Läd die Werte einer TileSet-XML.tsx
		 * 
		 * @param path Pfad mit Dateiname der auszulesenden XML
		 * @return struct TileSet.Data mit den gespeicherten Werten
		 */
	    public void createMapFromFile (string path) {
	    	//print("\tFuehre getTileSetDataFromFile aus\n");
	    	
	    	parse_file (path);
	    }


		/**
		 * Hilfsfunktion welche eine XML auslesen kann
		 *
		 * @return true bei Fehler, sonst false
		 */
	    private bool parse_file (string path) {
	    	//print("\tbeginne Datei zu parsen\n");
	        // Parse the document from path
	        Xml.Doc* doc = Parser.parse_file (path);
	        if (doc == null) {
	            error ("File %s not found or permissions missing", path);
	            //return true;
	        }

	        // Get the root node. notice the dereferencing operator -> instead of .
	        Xml.Node* root = doc->get_root_element ();
	        if (root == null) {
	            // Free the document manually before returning
	            delete doc;
	            print ("The xml file '%s' is empty", path);
	            return true;
	        }
	        string root_name = root->name;
	        print_indent ("XML document", path, '-');

	        // Print the root node's name
	        print_indent ("Root node", root_name);

			// Sucht nach den Werten innerhalb der Node
			parse_properties (root, root_name);

	        // Let's parse those nodes
	        parse_node (root);

	        // Free the document
	        delete doc;
	        return true;
	    }

		/**
		 * 
		 */
	    private void parse_node (Xml.Node* node) {
	    	//print("\tbeginne Node zu parsen\n");
	        this.indent++;
	        // Loop over the passed node's children
	        for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
	            // Spaces between tags are also nodes, discard them
	            if (iter->type != ElementType.ELEMENT_NODE) {
	                continue;
	            }

	            // Get the node's name
	            string node_name = iter->name;
	            // Get the node's content with <tags> stripped
	            string node_content = iter->get_content ();
	            print_indent (node_name, node_content);
			    
			    // Sucht nach den Werten innerhalb der Node
				parse_properties (iter, node_name);
	        
	            // Followed by its children nodes
	            parse_node (iter);
	        }
	        this.indent--;
	    }

		/**
		 * 
		 */
	    private void parse_properties (Xml.Node* node, string nodename) {
	    	//print("\tbeginne Werte zu parsen\n");
	    	TileSetMapData tilesetdata = TileSetMapData();

	    	switch (nodename) {
	    		case "tileset":
	    		break;
	    	}

	        // Loop over the passed node's properties (attributes)
	        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next) {
	            string attr_name = prop->name;
	            // Notice the ->children which points to a Node*
	            // (Attr doesn't feature content)
	            string attr_content = prop->children->content;

				print_indent (attr_name, attr_content, '|');
				switch (nodename) {
					case "map":
						switch (attr_name) {
							case "version":
								data.version = int.parse(attr_content);
							break;
							case "orientation":
								data.orientation = attr_content;
							break;
							case "width":
								data.width = int.parse( attr_content );
							break;
							case "height":
								data.height = int.parse( attr_content );
							break;
							case "tilewidth":
								data.tilewidth = int.parse( attr_content );
							break;
							case "tileheight":
								data.tileheight = int.parse( attr_content );
							break;
							default:
							break;
						}
					break;
					case "tileset":
						switch (attr_name) {
							case "firstgid":
								tilesetdata.firstgid = int.parse( attr_content );
							break;
							case "source":

							break;
						}
					break;
					case "layer":
						switch (attr_name) {
							case "name":

							break;
							case "width":

							break;
							case "height":

							break;
						}
					break;
					case "data":
						switch (attr_name) {
							case "tile":

							break;
						}
					break;
				}
	        }
	    }
	}

	public struct TileSetMapData {
		/**
		 * Quelle des TileSets.
		 */
		public TileSet source;
		/**
		 * TODO
		 */
		public uint firstgid;
	}
	/**
	 * Struktur fuer Maps
	 */
	public struct Data {
		/**
		 * orientation der Map.
		 */
		public string orientation;
		/**
		 * Version des Kartenformats?
		 */
		public uint version;
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
	}

	/**
	 * Name der Map.
	 */
	protected Data data = Data();
	//data.tileset = new Gee.List<TileSetMapData>();

	/**
	 * Konstruktor
	 */
	public Map() {
		data.layers = new Gee.ArrayList<Layer>();
		data.entities = new Gee.ArrayList<Entity>();
		data.tileset = new Gee.ArrayList<TileSetMapData?>();
	}
}
