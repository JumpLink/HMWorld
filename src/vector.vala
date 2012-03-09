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

	/**
	 * Dimension des Vektors.
	 */
	public int dim;
	/**
	 * Daten des Vektors.
	 */
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
	 
	public Vector addVector (Vector v) {
		if (dim == v.dim)
			for (int i = 0; i < dim; ++i)
				vec[i] += v.vec[i];
		return this;
	}
	
	public double ScalarProduct (Vector v) {
		double r = 0.0;
		if (dim == v.dim)
			for (int i = 0; i < dim; ++i)
				r += vec[i] * v.vec[i];
		return r;
	}
	
	public Vector VectorProduct (Vector v) {
		Vector r = new Vector (dim);
		if (dim == 3 && v.dim == 3) {
			r.vec[0] = vec[1] * v.vec[2] - vec[2] * v.vec[1];
			r.vec[1] = vec[2] * v.vec[0] - vec[0] * v.vec[2];
			r.vec[2] = vec[0] * v.vec[1] - vec[1] * v.vec[0];
		}
		return r;
	}
	
	public Vector divideByScalar (double s) {
		if (s != 0.0)
			for (int i = 0; i < dim; ++i)
				vec[i] /= s;
		return this;
	}
	
	public Vector multScalar (double s) {
		for (int i = 0; i < dim; ++i)
			vec[i] *= s;
		return this;
	}
	
	public double VectorNorm () {
		double r = 0.0;
		for (int i = 0; i < dim; ++i)
			r += vec[i] * vec[i];
		return Math.sqrt (r);
	}
	
	public Vector normVector () {
		return divideByScalar (VectorNorm ());	
	}
	
	public Vector multMatrix(Matrix m, Vector v) {
		for (int i = 0; i < dim; ++i) {
			vec[i] = 0;
			for (int j = 0; j < dim; ++j)
				vec[i] += vec[j] * m.mat[i,j]; /* TODO nicht sicher ob ij richtig. */
		}
		return this;
	}
}
