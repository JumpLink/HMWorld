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
 * Klasse fuer das Spielerobjekt
 */
public class Player : Entity {
	/**
	 * Name des Spielers
	 */
	public string name;

	/**
	 * Inventar
	 */
	public Inventory tools;

	/**
	 * Karte, auf der sich der Spieler befindet.
	 */
	public Map map;

	/**
	 * Position des Spielers
	 */
	public float x;
	public float y;

	/**
	 * Ausrichtung des Spielers
	 */
	public Direction direction;

	/**
	 * Konstruktor
	 */
	public Player() {
		this.name = "foobert";
		tools = new Inventory ();
	}
}
