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
using Gee;

public class OutgoingThread 
{
	/* Map mit Warteschlange der zu sendenden Pakete */
	public HashMap<uint32, Gee.Queue<string>> queues = new HashMap<uint32, Gee.Queue<string>>();
	/* Map mit den jeweiligen output-streams */
	public HashMap<uint32, OutputStream> streams = new HashMap<uint32, OutputStream>();

	public bool running = true;

	public void* thread_func () 
	{
		/* Sendeschleife */
		while (running) {
			MapIterator<uint32, OutputStream> it = streams.map_iterator();
			while (it.next()) {
				uint32 socketID = it.get_key();
				/* Schreibe Paketqueue */
				string toSend = queues.get(socketID).poll();
				while (toSend != null) {
					try {
						it.get_value().write(toSend.data);
					} catch (IOError e) {
						stderr.printf("%s", e.message);
					}
					toSend = queues[socketID].poll();
				}
			}
		}
		return null;
	}
}


// TODO: Problem beim disconnect (lauter messages mit laenge 0 werden gelesen)
// TODO: irgendwie sauberer zugriff auf die gemeinsamen Serverdaten

public class Server 
{

	/* Naechste zu vergebene ClientID */
	public uint32 currentID = 0;
	/* Sendethread */
	public static OutgoingThread outThread = new OutgoingThread();

	public bool incoming_connection (SocketConnection connection) 
	{
		/* Bestimmung der SocketID */
		uint32 socketID = ++currentID;
		outThread.streams.set(socketID, connection.get_output_stream());
		outThread.queues.set(socketID, new LinkedList<string>());

		/* TODO: queues befuellen mit "connected"-message */

		/* Bestimmung des Socketnamens */
		string socketName = "Error";
		try {
			InetSocketAddress remote = (InetSocketAddress)connection.get_remote_address();
			StringBuilder sb = new StringBuilder();
			sb.printf ("%s:%d", remote.get_address().to_string(), remote.get_port());
			socketName = sb.str;
		} catch (Error e) {
			stderr.printf ("Error: %s\n", e.message);
		}

		stdout.printf ("Incoming connection from client: %s, ID: %u\n", socketName, socketID);
		InputStream istream = connection.get_input_stream ();

		/* Input-Verbindungsschleife */
		bool connected = true;
		while (connected) {
			uint8[] message = new uint8[1024];
			try {
				/* Input vom Client verfuegbar? */
				/* Client noch da? */
					/* Paket lesen .. */
					ssize_t count = istream.read (message);
					stdout.printf ("Incoming message from %u:\n", socketID);
					StringBuilder s = new StringBuilder ();
					for (int i = 0; i < message.length; ++i)
						s.append_c ((char) message[i]);
					/* .. und entsprechend handeln */
					stdout.printf ("\"%s (%u)\"\n", s.str, (uint32)count);
					if (s.str == "q") {
						/* Client beendet */
						connected = false;
						/* TODO: queues befuellen mit disc-message */
					} else {
						/* Chatnachricht: Ueber Clients iterieren und queues befuellen */
						MapIterator<uint32, Gee.Queue<string>> it = outThread.queues.map_iterator();
						while (it.next()) {
							uint32 curID = it.get_key();
							if (curID != socketID)
								it.get_value().offer(s.str);
						}
					}
			} catch (IOError e) {
				stdout.printf ("Error: %s, connection %u lost!\n", e.message, socketID);
				connected = false;
			}
		}

		stdout.printf ("Client %u disconnected!\n", socketID);
		/* Client sauber entfernen */
		outThread.streams.unset(socketID);
		outThread.queues.unset(socketID);

		return false;
	}

	static int main (string[] args)
	{
		Server server = new Server();
		/* Socketservice erstellen (Parameter = maximale Threads) */
		ThreadedSocketService service = new ThreadedSocketService (1337);

		/* connect to the port */
		try {
			service.add_inet_port (8080, null);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}

		/* listen to the 'run' signal */ 
		/* this function will get called everytime a client attempts to connect */
		service.run.connect(server.incoming_connection);

		/* start the socket service */
		service.start();

		/* Ausgehenden Thread starten */
		// new Thread<void*>(string name, func*)
		unowned Thread<void*> thread = Thread.create<void*> (outThread.thread_func, false);

		/* Mainloop betreten */
		stdout.printf ("Server started, waiting for clients!\n");
		MainLoop loop = new MainLoop(null, false);
		loop.run();
		return 0;
	}
}
