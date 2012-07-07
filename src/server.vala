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

class Server {

	public static bool incoming_connection (SocketConnection connection) {
		print("Received Connection from client!\n");
		InputStream istream = connection.get_input_stream ();
		OutputStream ostream = connection.get_output_stream ();
		bool a = true;
		while (a) {
			uint8[] message = new uint8[1024];
			try {
				ssize_t count = istream.read  (message);
				print (count.to_string() + " bytes read\n");
				StringBuilder s = new StringBuilder ();
				for (int i = 0; i < message.length; ++i)
					s.append_c ((char) message[i]);
				print("Message was: \"%s\"\n", s.str);
				if (s.str == "q") {
					print("Client disconnected!\n");
					a = false;
				}
				count = ostream.write ("thanks".data);
				print (count.to_string() + " bytes written\n");
			} catch (IOError e) {
				print("Error: %s\n", e.message);
				a = false;
			}
		}
		return false;
	}

	static int main (string[] args)
	{
		/* initialize glib */
		//g_type_init();

		//GError * error = NULL;

		/* create the new socketservice */
		ThreadedSocketService service = new ThreadedSocketService (1337);

		/* connect to the port */
		try {
			service.add_inet_port (8080, null);
		} catch (Error e) {
			print("Error: %s\n", e.message);
		}

		/* listen to the 'run' signal */ 
		/* this function will get called everytime a client attempts to connect */
		service.run.connect(incoming_connection);

		/* start the socket service */
		service.start();

		/* enter mainloop */
		print ("Waiting for client!\n");
		MainLoop loop = new MainLoop(null, false);
		loop.run();
		return 0;
	}
}
