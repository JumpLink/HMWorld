/* Copyright (C) 2012  Pascal Garber
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 */

using GLib;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer Ein-/Ausgabe-Verarbeitung.
	 */
	abstract class Input {
		public static uchar UP='w';
		public static uchar RIGHT='d';
		public static uchar DOWN='s';
		public static uchar LEFT='a';
		public static uchar ACTION = 'f';
		public static uchar USE = 'e';
		public static uchar SWAP = 'r';
	}
}