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

/**
 * Klasse fuer Maps
 */
public class Map {
	/** Name der Map. */
	public string name;
	/** Layer der Map. */
	public List<Layer> layers;
	/** Entities auf der Map */
	public List<Entity> entities;

	/**
	 * Konstruktor
	 */
	public Map() {
		name = "new Map";
		layers = new List<Layer>();
		entities = new List<Entity>();
	}
}
