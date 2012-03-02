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
 * Einfache Klasse fuer Vektoren und deren Mathematik.
 */
public class Vector {

	/** Dimension des Vektors. */
	public int dim;
	/** Daten des Vektors. */
	public double[] vec;
	
	/**
	 * Konstruktor.
	 * 
	 * Erzeugt einen nicht initialisierten Vektor.
	 * 
	 * @param dim Dimension des Vektors.
	 */
	public Vector(int dim) {
		this.dim = dim;
		this.vec = new double[dim];
	}
	
	/* Rechenoperationen */
	/* TODO:
	 * Addition
	 * Punktprodukt
	 * Kreuzprodukt
	 * Division durch Skalar
	 * Multiplikation mit Skalar
	 * Normalisieren
	 * Laenge bestimmen
	 */
	
	public Vector multMatrix(Matrix m, Vector v) {
		for (int i = 0; i < dim; ++i) {
			vec[i] = 0;
			for (int j = 0; j < dim; ++j)
				vec[i] += vec[j] * m.mat[i,j]; /* TODO nicht sicher ob ij richtig. */
		}
		return this;
	}
}
