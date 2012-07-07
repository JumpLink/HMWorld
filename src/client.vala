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

using GLib;

class Client {

	public static int main (string[] args)
	{
		/* create a new connection */
		SocketConnection connection = null;
		SocketClient client = new SocketClient();

		try {
			connection = client.connect_to_host ("localhost:8080", 8080, null);
		} catch (Error e) {
			print("Error: %s\n", e.message);
		}

		/* use the connection */
		InputStream istream = connection.get_input_stream ();
		OutputStream ostream = connection.get_output_stream ();
		bool running = true;
		while (running) {
			string message = stdin.read_line();
			uint8[] answerbuffer = new uint8[1024];
			if(message == "q")
				running = false;
			try {
				ssize_t count = ostream.write (message.data);
				print (count.to_string() + " bytes written\n");
				print("Message was: \"%s\"\n", message);
				count = istream.read (answerbuffer);
				StringBuilder s = new StringBuilder ();
				for (int i = 0; i < answerbuffer.length; ++i)
					s.append_c ((char) answerbuffer[i]);
				print("Answer was: \"%s\"\n", s.str);
			} catch (IOError e) {
				print("Error: %s\n", e.message);
				running = false;
			}
		}
		return 0;
	}
}

