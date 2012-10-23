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

public class ClientReceiveThread {

	public InputStream istream;
	public bool running = true;
	uint8[] buffer = new uint8[1024];

	public void* thread_func () 
	{
		while (running) {
			try {
				ssize_t count = istream.read(buffer);
				if(count==0) {GLib.Process.exit(0);}
				StringBuilder s = new StringBuilder ();
				for (int i = 0; i < buffer.length; ++i)
					s.append_c ((char) buffer[i]);
				print("Someone said: \"%s\"\n", s.str);
			} catch (IOError e) {
				stdout.printf ("Error: %s", e.message);
			}
		}
		return null;
	}

}

public class Client 
{
	public static int main (string[] args)
	{
		const uint16 PORT = 8080;
		const string HOST = "localhost";
		/* Verbindung herstellen */
		SocketConnection connection = null;
		SocketClient client = new SocketClient();

		try {
			connection = client.connect_to_host (HOST, PORT, null);
			print("Connected to: %s:%u\n",HOST, PORT);
		} catch (Error e) {
			print("Error: %s\n", e.message);
		}

		/* IO-Streams */
		InputStream istream = connection.get_input_stream ();
		OutputStream ostream = connection.get_output_stream ();

		/* Input-Thread starten */
		ClientReceiveThread t = new ClientReceiveThread();
		t.istream = istream;
		Thread<void*> crThread = new Thread<void*>("crThread", t.thread_func);

		/* Output-Schleife */
		bool running = true;
		while (running) {
			string message = stdin.read_line();
			/* beenden mit q */
			if (message == "q") {
				running = false;
				t.running = false;
			}
			try {
				ssize_t count = ostream.write (message.data);
				if(count==0) {GLib.Process.exit(0);}
				stdout.printf ("I said: \"%s\"\n", message);
			} catch (IOError e) {
				print("Error: %s\n", e.message);
				running = false;
			}
		}
		t.running = false;
		crThread.join();
		return 0;
	}
}

