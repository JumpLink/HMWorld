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
	/**
	 * Klasse fuer das Spielerinventar.
	 */
	 public class Inventory {
	 	/**
	 	 * Primaeres Werkzeug (ausgeruestet).
	 	 */
	 	public Tool primary;

	 	/**
	 	 * Sekundaeres Werkzeug (Reserve).
	 	 */
	 	public Tool secondary;

	 	/**
		 * Konstruktor
		 */
	 	public Inventory () {
	 		primary = new Hoe ();
	 		secondary = new PotatoSeed ();
	 	}

	 	/**
	 	 * Ruestet sekundaeres Werkzeug aus.
	 	 */
	 	public void swapTools () {
	 		Tool tmp = primary;
	 		primary = secondary;
	 		secondary = tmp;
	 		print ("Werkzeug gewechselt!\n");
	 	}

	 	/**
	 	 * Fuegt ein neues Werkzeug hinzu.
	 	 * @param t Das neue Werkzeug.
	 	 * @return Das alte Primaerwerkzeug.
	 	 */
	 	public Tool equip (Tool t) {
	 		Tool tmp = primary;
	 		primary = t;
	 		return tmp;
	 	}

	 	/**
	 	 * Benutzt ausgeruestetes Werkzeug mit Umgebung.
	 	 * @param m Die Umgebung.
	 	 * @param x Die X-Position.
	 	 * @param y Die Y-Position.
	 	 * @param d Die Richtung.
	 	 */
	 	public void use (Map m, uint x, uint y, Direction d, Storage s) {
	 		primary.use (m, x, y, d, s);
	 	}
	 }
}