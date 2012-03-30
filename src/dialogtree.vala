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
	 * Klasse fuer einen Dialogbaum.
	 */
	public class DialogTree {
		private string answer;
		private string question;
		private int choice = 0;
		private DialogTree[] children;

		public DialogTree (string q, string a, DialogTree[] c) {
			question = q;
			answer = a;
			children = c;
		}

		public void chooseAnswer (bool next) {
			choice = (choice + (next ? 1 : -1)) % children.length;
		}

		public string getText () {
			string text = question + "\n";
			for (uint i = 0; i < children.length; ++i) {
				text += i.to_string() + " : " + children[i].answer + ((i == choice) ? "!" : "") + "\n";			
			}
			return text;
		}

		public DialogTree getAnswer () {
			return children[choice];
		}
	}
}