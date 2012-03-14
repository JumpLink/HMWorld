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
using Gdk;
//using GLib; //Fuer assertions

using HMP;
namespace HMP {
	/**
	 * Klasse fuer TileSets
	 */
	public class TileSet {

		/**
		 * Klasse fuer XML-Operationen
		 */
		class XML : HMP.XML {
		    
			/**
			 * Läd die Werte einer TileSet-XML.tsx
			 * 
			 * @param folder Ordner in dem sich die auszulesende XML befindet
			 * @param filename Dateiname der auszulesenden XML
			 */
		    public void getDataFromFile (string folder, string filename, out string name, out uint tilewidth, out uint tileheight, out string source, out string trans, out uint width, out uint height) {
		    	//print("\tFuehre getTileSetDataFromFile aus\n");
		    	Gee.HashMap<string, string> tileset_global_properties = new Gee.HashMap<string, string>();
		    	Gee.HashMap<string, string> tileset_image_properties = new Gee.HashMap<string, string>();
				
		    	parse_file (folder+filename, tileset_global_properties, tileset_image_properties);
		    	
		    	// Zuweisung der geparsten Werte
		    	name = (string) tileset_global_properties.get ("name");
		    	tilewidth = int.parse(tileset_global_properties.get ("tilewidth"));
		    	tileheight = int.parse(tileset_global_properties.get ("tileheight"));
		    	
		    	source = (string) tileset_image_properties.get ("source");
		    	trans = (string) tileset_image_properties.get ("trans");
		    	width = int.parse(tileset_image_properties.get ("width"));
		    	height = int.parse(tileset_image_properties.get ("height"));
		    }


			/**
			 * Hilfsfunktion welche eine XML auslesen kann
			 *
			 * @return true bei Fehler, sonst false
			 */
		    private bool parse_file (string path, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
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

		        print_indent ("XML document", path, '-');

		        // Print the root node's name
		        print_indent ("Root node", root->name);
		        
		    	// Prüfe ob root bereits eines der gesuchten Nodes beinhaltet
				switch (root->name) {
					case "tileset":
						//print("\t%s in root gefunden\n",root->name);
						parse_properties (root, tileset_global_properties);
					break;
					case "image":
						//print("\t%s in root gefunden\n",root->name);
						parse_properties (root, tileset_image_properties);
					break;
					default:
						print("Keine passende Node gefunden!\n");
					break;
				}
		        
		        // Let's parse those nodes
		        parse_node (root, tileset_global_properties, tileset_image_properties);

		        // Free the document
		        delete doc;
		        return true;
		    }

			/**
			 * 
			 */
		    private void parse_node (Xml.Node* node, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
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
				    
					// Prüfe ob node eines der gesuchten Nodes beinhaltet
					switch (iter->name) {
						case "tileset":
							//print("\t%s in node gefunden\n",iter->name);
							parse_properties (iter, tileset_global_properties);
						break;
						case "image":
							//print("\t%s in node gefunden\n",iter->name);
							parse_properties (iter, tileset_image_properties);
						break;
						default:
							print("\tKeine (weiteren) passende Nodes gefunden!\n");
						break;
					}
		        
		            // Followed by its children nodes
		            parse_node (iter, tileset_global_properties, tileset_image_properties);
		        }
		        this.indent--;
		    }

			/**
			 * 
			 */
		    private void parse_properties (Xml.Node* node, Gee.HashMap<string, string> properties) {
		    	//print("\tbeginne Werte zu parsen\n");
		        // Loop over the passed node's properties (attributes)
		        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next) {
		            string attr_name = prop->name;
		            // Notice the ->children which points to a Node*
		            // (Attr doesn't feature content)
		            string attr_content = prop->children->content;

					print_indent (attr_name, attr_content, '|');
					properties.set(attr_name, attr_content);
		        }
		    }
		}
		/**
		 * Name des TileSets.
		 */
		public string name;
		/**
		 * Dateiname des TileSets.
		 */
		public string filename;
		/**
		 * Breite eines Tiles
		 */
		public uint tilewidth;
		/**
		 * Hoehe eines Tiles
		 */
		public uint tileheight;
		/**
		 * Dateiname des TileSet-Bildes
		 */
		public string source;
		/**
		 * Transparente Farbe im TileSet
		 */
		public string trans;
		/**
		 * Gesamtbreite des TileSets
		 */
		public uint width;
		/**
		 * Gesamthoehe des TileSets
		 */
		public uint height;
		/**
		 * Die Tiles in Form eines 2D-Array des TileSets
		 */
		public Tile[,] tile;
		/** Array fuer die einzelnen Tiles */	
		//private Tile[,]	 tiles;

		/**
		 * Konstruktor
		 */
		public TileSet() {
			print("Erstelle TileSet Objekt\n");
			//tiles = new Tile[,];
		}
		/**
		 * Dekonstruktor
		 */
		~TileSet() {
			print("Lösche TileSet Objekt\n");
		}
		public void loadFromPath(string path, string filename) {
			this.filename = filename;
			var xml = new XML ();
			xml.getDataFromFile(path, filename, out name, out tilewidth, out tileheight, out source, out trans, out width, out height);
			loadTiles();
		}

		public uint getTotalWidth() {
			return width;
		}

		public uint getTotalHeight() {
			return height;
		}

		public uint getTileWidth() {
			return tilewidth;
		}

		public uint getTileHeight() {
			return tileheight;
		}
		public uint getCountY() {
			return (int) getTotalHeight() / getTileHeight();
		}

		public uint getCountX() {
			return (int) getTotalWidth() / getTileWidth();
		}
		/**
		 * Gibt den Namen des TileSets zurück
		 * @return Name des TileSets
		 */
		public string getName() {
			return name;
		}
		/**
		 * Gibt den Dateinamen des TileSets zurück
		 * @return Dateiname des TileSets
		 */
		public string getFilename() {
			return filename;
		}
		/**
		 * Gibt den Sourcenamen des TileSets zurück
		 * @return source des TileSets
		 */
		public string getSource() {
			return source;
		}
		/**
		 * Gibt ein gesuchtes Tile anhand seines Index zurueck.
		 *
		 * @param index Index des gesuchten Tiles
		 */
		public HMP.Tile getTileFromIndex(uint index)
		requires (index >= 0) {
			print("==GETTILEFROMINDEX==\n");
			uint count = 0;
			bool found = false;
			HMP.Tile result = null;
			for (int y=0;y<height&&!found;y++) {
				for (int x=0;x<width&&!found;x++) {
					if (count == index) {
						found = true;
						result = tile[x,y];
					}
					count++;
				}
			}
			return result;
		}
		/**
		 * Ladet die Pixel fuer die Tiles.
		 * Zur Zeit alle noch als RegularTile.
		 */
		private void loadTiles() {
			Texture tex = new Texture();
			tex.loadFromFile("./data/tileset/"+getSource());
			int count_y = (int) getCountY();
			int count_x = (int) getCountX();
			int split_width = (int) getTileWidth();
			int split_height = (int) getTileHeight();
			tile = new Tile[getCountY(),getCountX()];
			//int count = 0;
			Pixbuf pxb = tex.get_Pixbuf();
			print("=====LOADTILES=====\n");
			for(int y = 0; y < count_y; y++) {
				for(int x = 0; x < count_x; x++) {
					Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), split_width, split_height);
					//print("y: %i x:%i split_width:%i split_height:%i count %i", y, x, split_width, split_height, count);
					pxb.copy_area((int) split_width*x, (int) split_height*y, (int) split_width, (int) split_height, split, 0, 0);
					tile[y,x] = new RegularTile.FromPixbuf(split);
					//count++;
					//tile[y,x].printValues();
				}
			}
			print("Tiles zerteilt\n");
		}
		/**
		 * Gibt alle Werte Tiles auf der Konsole aus
		 */
		public void printTiles() {
			print("==Tiles==\n");
			for (uint y=0;y<getCountY();y++) {
				for (uint x=0;x<getCountX();x++) {
					//print("%u ", tile[x,y].type);
					tile[x,y].printValues();
				}
				print("\n");
			}
			print("\nWenn du dies siehst konnten alle Tiles durchlaufen werden\n");
		}
		/**
		 * Gibt alle Werte des TileSets auf der Konsole aus
		 */
		public void printValues() {
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("tilewidth: %u\n", tilewidth);
			print("tileheight: %u\n", tileheight);
			print("source: %s\n", source);
			print("trans: %s\n", trans);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alle Werte und die Tiles des TileSets auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printTiles();
		}
	}
}