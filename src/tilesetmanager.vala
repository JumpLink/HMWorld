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
using Gee;
using GLib;
/**
 * Klasse fuer TileSetManager
 */
public class TileSetManager {
	Gee.List<TileSet> tileset;
	string path;
	/**
	 * Konstruktor
	 */
	public TileSetManager() {
		print("Erstelle TileSet\n");
		tileset = new Gee.ArrayList<TileSet>();
	}
	/**
	 * Dekonstruktor
	 */
	~TileSetManager() {
		print("Lösche TileSet\n");
	}

	public void loadAllFromPath(string path = "./data/tileset") {
		this.path = path;
		File directory = File.new_for_path(path);
		FileEnumerator enumerator;
	
	    try {
	    	FileInfo file_info;
	    	// 'Oeffnet' das Verzeichnis path
	        directory = File.new_for_path (path);
	        // Ladet die Dateien die sich im Verzeichnis path befinden
	        enumerator = directory.enumerate_children (FILE_ATTRIBUTE_STANDARD_NAME, 0);
	        // Durchläuft alle gefundenen Dateien und werte desen Informationen zur Weiterverarbeitung aus
	        while ((file_info = enumerator.next_file ()) != null) {
	        	string filename = file_info.get_name ();
	        	string extension;

	        	print ("%s\n", filename);
	        	//print ("Content type: %s\n", file_info.get_content_type ());
	        	//extrahiert die Dateiendung
	        	extension = filename.substring(filename.last_index_of (".", 0), -1);
	        	print ("extension: %s\n", extension);
	            if (extension == ".tsx") {
	            	TileSet tmptileset = new TileSet();
	            	tmptileset.loadFromPath(path+filename);
	            	tileset.add(tmptileset);
	            }
	        }

	    } catch (Error e) {
	        error ("Error: %s\n", e.message);
	        //return 1;
	    }
	}

	public TileSet get(string name) {
		foreach (TileSet ts in tileset)
				if (ts.getName() == name) {
					print("TileSet gefunden!\n");
					return ts;
				}
					
		return new TileSet();
	}

	/*public TileSet loadFromPath(string filename) {

		return loadFromPath(path+filename);
	}*/

	public void printAll() {
		foreach (TileSet ts in tileset) {
				ts.printValues ();
    	}
	}
}
