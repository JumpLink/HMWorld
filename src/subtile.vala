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
	public class SubTile {
	 	EdgeShape edge;

	 	public SubTile () {
	 		edge = EdgeShape.FULL;
	 	}
	 	public void calcEdge (uint [] neighbours, uint type, uint location) {
	 		assert (neighbours.length == 3);
	 		if (neighbours[0] == type && neighbours[1] == type && neighbours[2] == type)
	 			edge = EdgeShape.FULL;
	 		else if (neighbours[0] == type && neighbours[1] != type && neighbours[2] == type)
	 			edge = EdgeShape.INNER_CORNER;
	 		else if (neighbours[0] != type && neighbours[2] != type)
	 			edge = EdgeShape.OUTER_CORNER;
	 		else if (neighbours[0] == type && neighbours[1] == type && neighbours[2] != type)
	 			edge = (location % 2 == 0) ? EdgeShape.V_LINE : EdgeShape.H_LINE;
	 		else if (neighbours[0] != type && neighbours[1] == type && neighbours[2] == type)
	 			edge = (location % 2 == 0) ? EdgeShape.H_LINE : EdgeShape.V_LINE;
	 	}
	}
}