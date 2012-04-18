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
		public const uchar UP='w';
		public const uchar RIGHT='d';
		public const uchar DOWN='s';
		public const uchar LEFT='a';
		public const uchar ACTION = 'f';
		public const uchar USE = 'e';
		public const uchar SWAP = 'r';
		/**
		 * Keycode der ESC-Taste
		 */
		public const uchar ESC = 27;
		public abstract void init();
	}
}