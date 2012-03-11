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
	Gee.List<Map> map;
	/**
	 * Konstruktor
	 */
	public MapManager() {
		print("Erstelle MapManager\n");
		map = new Gee.ArrayList<Map>();
	}
	/**
	 * Dekonstruktor
	 */
	~MapManager() {
		print("Lösche MapManager\n");
	}

	/**
	 * Ladet alle Maps aus dem Verzeichniss "path"
	 *
	 * Dabei werden alle Dateien mit der Endung .tsx berücksichtigt.
	 * Das Parsen der XML wird von der Klasse Map.XML übernommen.
	 * Anschließend wird jede Map in eine ArrayList gespeichert.
	 *
	 * @param path der Ordnername aus dem gelesen werden soll.
	 */
	public void loadAllFromPath(string path = "./data/map") {
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
	            	Map tmp_map = new Map(path, filename);
	            	map.add(tmp_map);
	            }
	        }

	    } catch (Error e) {
	        error ("Error: %s\n", e.message);
	        //return 1;
	    }
	}

	/**
	 * Gibt die Map mit dem Dateinamen "source" zurück
	 *
	 * @param source Ort der gesuchten Map
	 * @return Bei Erfolg die gefundene Map, sonst ein neues Objekt Map
	 */
	public TileSet getFromSource(string source) {
		foreach (TileSet m in map)
				if (m.source == source) {
					print("Map gefunden!\n");
					return m;
				}
					
		return new Map();
	}

	/**
	 * Gibt die Werte aller Maps in der Liste aus.
	 */
	public void printAll() {
		foreach (Map m in map) {
				m.printValues ();
    	}
	}
}
