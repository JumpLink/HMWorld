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
	 * Klasse fuer Maps.
	 * Diese Klasse dient zur Speicherung von Mapinformationen.
	 * Sie kann zudem die Maps auf der Konsole ausgeben und eine Map-Datei laden.
	 */
	public class Map {
		/**
		 * Unterklasse von Maps als Hilfe fuer das Laden einer XML-basierten Map-Datei.
		 * Wir verwenden dafuer das Dateiformat von "Tiled", einem Mapeditor
		 * der hier zu finden ist: [[http://www.mapeditor.org/|mapeditor.org]]
		 * Derzeit werden noch keine komprimierten Dateien unterstuetzt.
		 * Die zu ladenden Maps werden fuer gewoehnlich von der Klasse HMP.MapManager
		 * uebernommen.
		 * Die definitionen des Kartenformats sind [[https://github.com/bjorn/tiled/wiki/TMX-Map-Format|hier]] zu finden.
		 *
		 * @see HMP.MapManager
		 */
		class XML : HMP.XML {
			/**
			 * Speichert den path der zu bearbeitenden Mapdatei
			 */
			string path;
			/**
			 * Hilsvariable mit Dateityp von libxml2, fuer weitere Informationen siehe
			 * [[http://xmlsoft.org/html/libxml-tree.html#xmlDoc|xmlsoft.org]]
			 * und [[http://valadoc.org/libxml-2.0/Xml.Doc.html|valadoc.org]]
			 */
			private Xml.Doc* doc;
			/**
			 * Hilsvariable mit Dateityp von libxml2, fuer weitere Informationen siehe
			 * [[http://xmlsoft.org/html/libxml-xpath.html#xmlXPathContext|xmlsoft.org]]
			 * und [[http://valadoc.org/libxml-2.0/Xml.XPath.Context.html|valadoc.org]]
			 */
			Context ctx;
			/**
			 * Konstrukter der internen XML-Klasse.
			 * Hier wird der Parser initialisiert und die uebergebene Datei vorbereitet.
			 *
			 * @param path Pfadangabe der vorzubereitenden XML-Datei
			 */
			public XML(string path) {
				//print("Erstelle XML-Objekt vom Path %s\n", path);
				Parser.init ();
				this.path = path;
				doc = Parser.parse_file (path);
				if(doc==null) print("failed to read the .xml file\n");
				
				ctx = new Context(doc);
				if(ctx==null) print("failed to create the xpath context\n");
			}
			/**
			 * Dekonstrukter der internen XML-Klasse.
			 * Hier wird der Parser gesaeubert und Variablen wieder freigegeben.
			 */
			~XML() {
				delete doc;
				Parser.cleanup ();
			}
			/**
			 * In dieser Methode werden die globalen Mapwerte aus der XML gelesen
			 * und als Parameter zurueck gegeben. In der XML sind es die properties des map-Tags
			 *
			 * @param orientation Die Ausgelsene Orientierung der Karte wird hier gespeichert, es wird nur "orthogonal" unterstützt.
			 * @param version The TMX format version, generally 1.0.
			 * @param width The map width in tiles.
			 * @param height The map height in tiles.
			 * @param tilewidth The width of a tile.
			 * @param tileheight The height of a tile.
			 */
			public void loadGlobalMapProperties (out string orientation, out string version, out uint width, out uint height, out uint tilewidth, out uint tileheight) {
				//XPath-Expression verarbeiten
				Xml.Node* node = evalExpression("/map");
				//properties des resultats verarbeiten.
				Gee.HashMap<string, string> properties = loadProperties(node);
				//geparsten properties speichern.
				orientation = (string) properties.get ("orientation");
				version = (string) properties.get ("version");
				width = int.parse(properties.get ("width"));
				height = int.parse(properties.get ("height"));
				tilewidth = int.parse(properties.get ("tilewidth"));
				tileheight = int.parse(properties.get ("tileheight"));
			}
			/**
			 * In dieser Methode werden die TileSet-Werte aus der XML gelesen
			 * und als return zurueck gegeben.
			 * In der XML sind dies die properties des tileset-Tags.
			 * Eine Karte kann mehrere TileSets beinhalten, daher wird mit einer Liste von TileSets gearbeitet.
			 *
			 * @return Liste mit allen gefundenen TileSets
			 */
			public Gee.List<HMP.TileSetReference> loadTileSets () {
				Gee.List<HMP.TileSetReference> tileset = new Gee.ArrayList<HMP.TileSetReference>(); //Speichert diie TileSets in einer Liste
				//XPath-Expression ausfuehren
				unowned Xml.XPath.Object obj = ctx.eval_expression("/map/tileset");
				if(obj==null) print("failed to evaluate xpath\n");
				//Durchläuft alle Nodes, also alle resultierten TileSet-Tags
				for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
					//Holt entsprechenden Layer
					Xml.Node* node = obj.nodesetval->item(i);
					//Parst dessen properties
					Gee.HashMap<string, string> properties = loadProperties(node);
					//string zerschneiden um den Dateinamen zu bekommen
					string filename = HMP.File.PathToFilename((string) properties.get ("source"));
					//Speichert die geparsten properties
					HMP.TileSet source = TILESETMANAGER.getFromFilename(filename);
					int firstgid = int.parse(properties.get ("firstgid"));
					//Den zusammengestellten neuen TileSet in die Liste einfuegen
					tileset.add( new TileSetReference(firstgid, source));
				}
				return tileset;
			}
			/**
			 * In dieser Methode werden die Layer-Werte aus der XML gelesen
			 * und als return zurueck gegeben.
			 * In der XML sind dies die properties und die Kinder des layer-Tags.
			 * Eine Karte kann mehrere Layer beinhalten, daher wird mit einer Liste von Layern gearbeitet.
			 *
			 * @return Gee.ArrayList vom Typ HMP.Layer aller Layer
			 * @see HMP.Layer
			 * @see Gee.ArrayList
			 */
			public Gee.List<Layer> loadLayers (Gee.List<HMP.TileSetReference> tilesetrefs) {
				Gee.List<Layer> layer = new Gee.ArrayList<Layer>(); //Speichert die Layers
				//XPath-Expression ausfuehren
				unowned Xml.XPath.Object obj = ctx.eval_expression("/map/layer");
				if(obj==null) print("failed to evaluate xpath\n");
				//Durchläuft alle Nodes, also alle resultierten Layer-Tags
				for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
					//Holt entsprechenden Layer
					Xml.Node* node = obj.nodesetval->item(i);
					//Parst dessen properties
					Gee.HashMap<string, string> properties = loadProperties(node);
					//Speichert die geparsten properties
					string name = (string) properties.get ("name");
					int width = int.parse(properties.get ("width"));
					int height = int.parse(properties.get ("height"));
					int.parse(properties.get ("height"));
					//print("Lade Tiles\n");
					//Holt sich auch gleich den Tile-Tag
					Tile[,] tiles = loadTiles(i, width, height, tilesetrefs);
					//print("Fuege Layer mit Namen %s hinzu\n", properties.get ("name"));
					double z = 0; //Zu speichernder Z-Wert
					//Holt sich auch gleich den Z-Wert
					loadLayerZ(i, out z);
					//Den zusammengestellten Layer in die Liste einfuegen
					layer.add( new Layer.all( name, z, width, height, tiles));
				}
				return layer;
			}
			/**
			 * In dieser Methode wird der Z-Wert aus der XML gelesen
			 * und als Parameter zurueck gegeben.
			 * In der XML ist der Z-Wert ein zusaetlicher costum Wert, ziehe dazu [[https://github.com/bjorn/tiled/wiki/TMX-Map-Format|hier]] unter dem properties-tag
			 *
			 * @param layer_number Layer-Index aus dem der Z-Wert gewonnen werden soll. Wird als Information fuer die richtige XPath-Expression benoetigt.
			 * @param z Z-Wert der ausgelesen werden und gespeichert werden soll.
			 * @return false bei Fehler sonst true
			 */
			private bool loadLayerZ (uint layer_number, out double z) {
				Xml.Node* node = evalExpression("/map/layer["+(layer_number+1).to_string()+"]/properties/property");
				Xml.Attr* attr = node->properties;
				string name;
				string content;
				z = 0;
				while ( attr != null) {
					name = (string) attr->name;
					content = (string) attr->children->content;
					//print("Attribute: \tname: %s\tvalue: %s\n", name, content);
					if (name == "name" && content == "z") {
						//print("Z-Wert folgt\n");
						attr = attr->next;
						if (attr != null) {
							name = (string) attr->name;
							content = (string) attr->children->content;
							if (name == "value" ) {
								//print("Attribute: \tname: %s\tvalue: %s\n", name, content);
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
			/**
			 * In dieser Methode werden die Tile-Werte aus der XML gelesen und als return zurueck gegeben.
			 * In der XML sind es jeweils nur ein propertie mit dem namen "gid" des entsprechenden tile-Tags.
			 * Eine Karte kann mehrere Tiles beinhalten, daher wird mit einem Array von Tiles gearbeitet.
			 *
			 * @return Array mit den geparsten Tiles
			 */
			public Tile[,] loadTiles (uint layer_number, uint width, uint height, Gee.List<HMP.TileSetReference> tilesetrefs) {
				HMP.Tile[,] tiles = new Tile[height,width]; // Zur Speicherung der Tiles
				HMP.TileSetReference tmp_tilesetref;
				HMP.Tile tmp_tile;
				Gee.HashMap<string, string> properties;
				Xml.Node* node;
				uint gid;
				//XPath-Expression ausfuehren
				unowned Xml.XPath.Object obj = ctx.eval_expression("/map/layer["+(layer_number+1).to_string()+"]/data/tile");
				if(obj==null) print("failed to evaluate xpath\n");
				//Alle Tiles des XPath-Expression-Ergebnisses durchlaufen
				for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
					//Holt sich das Tile
					node = obj.nodesetval->item(i);
					//Parst die gid
					properties = loadProperties(node);
					//Neues Tile mit geparster gid
					gid = int.parse(properties.get ("gid"));
					//Gid = 0 bedeutet kein tile
					if(gid > 0) {
						// Sucht das passende TileSetRef fuer die gid
						tmp_tilesetref = HMP.Map.getTileSetRefFromGid(tilesetrefs, gid);
						// Berechnet den Index des Tiles anhand der Gid und der firstgid und gibt das entsprechende Tile mit dem Index zurueck.
						tmp_tile = tmp_tilesetref.source.getTileFromIndex(gid - tmp_tilesetref.firstgid);
					}
					else {
						//TODO echtes leeres Tile welches wirklich gar nichts hat wird benoetigt
						tmp_tile = new RegularTile();
						tmp_tile.type = TileType.NO_TILE;
					}
					//print("y: %u, x: %u\t",(uint)((i/width)),(uint)(i%width));
					//Tile dem Array mit berechneten x- und y-Werten hinzufuegen
					tiles[(uint)(i/width),(uint)(i%width)] = tmp_tile;

				}
				return tiles;
			}
			/**
			 * Allgemeine Hilfsmethode fuer das Parsen von properties eines Knotens.
			 *
			 * @param node der zu parsenden properties.
			 * @return Liste mit den geparsten properties, key ist der propertiename und value ist der propertievalue.
			 */
			protected Gee.HashMap<string, string> loadProperties(Xml.Node* node) {
				Xml.Attr* attr = node->properties;
				Gee.HashMap<string, string> properties = new Gee.HashMap<string, string>();

				while ( attr != null ) {
					//print("Attribute: \tname: %s\tvalue: %s\n", attr->name, attr->children->content);
					properties.set(attr->name, attr->children->content);
					attr = attr->next;
				}
				return properties;
			}
			/**
			 * Allgemeine Hilfsmethode fuer das ausfuhren einer XPath-Expression.
			 *
			 * @param expression Auszufuehrende Expression als String.
			 * @return node mit dem Ergebniss der Expression.
			 */
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
		/**
		 * orientation der Map.
		 */
		public string orientation;
		/**
		 * Version des Kartenformats, fuer gewoehnloch 1.0
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
		public Gee.List<HMP.TileSetReference> tileset;
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
			tileset = new Gee.ArrayList<TileSetReference>();
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
			tileset = xml.loadTileSets();
			layers = xml.loadLayers(tileset);
		}
		/**
		 * Gibt das zur gid passende TileSetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids
		 * @param tilesetrefs Liste von TileSetReference's in der gesucht werden soll.
		 * @param gid Die zu der das passende TileSet gesucht werden soll.
		 * @return Das gefundene TileSetReference.
		 */
		public static TileSetReference getTileSetRefFromGid(Gee.List<HMP.TileSetReference> tilesetrefs, uint gid) {	
			HMP.TileSetReference found = tilesetrefs[0];
			foreach (HMP.TileSetReference tsr in tilesetrefs) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			//print("Das passende TileSet ist %s\n", found.source.name);
			return found;
		}
		/**
		 * Gibt den Index eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Index aus der Layerliste
		 */
		public int getIndexOfLayerName(string name) {
			foreach (Layer i in layers) {
				if (name == i.name) {
					return layers.index_of(i);
				}
			}
			return -1;
		}
		public void draw() {
			//print("==DrawMap==\n");
			foreach (Layer l in layers) {
				l.draw();
			}
			//layers[0].draw();
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
		 * Gibt die Werte aller TileSets der Map auf der Konsole aus
		 */
		public void printTileSets() {
			print("====ALL TILESETS FROM MAP %s====\n", filename);
			foreach (HMP.TileSetReference tsr in tileset) {
				tsr.printValues();
			}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printLayers();
			printTileSets();
		}
	}
}
