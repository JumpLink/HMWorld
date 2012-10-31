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

using rpg;
using Gtk;
using WebKit;
using Posix;

public class Browser {

    private const string HOME_URL = "http://localhost:3000/";
    private const string DEFAULT_PROTOCOL = "http";

    private Regex protocol_regex;

    private WebView web_view;
    private Window window;
    public Browser () {

        try {
            this.protocol_regex = new Regex (".*://.*");
        } catch (RegexError e) {
            critical ("%s", e.message);
        }

        create_widgets ();
        connect_signals ();
    }

    private bool create_widgets () {
        this.web_view = new WebView ();
        ScrolledWindow scrolled_window;
        try {
            var builder = new Builder ();
            builder.add_from_file ("ui/window.ui");
            builder.connect_signals (null);
            window = builder.get_object ("window") as Window;
            window.maximize();
            //window.fullscreen();
            scrolled_window = builder.get_object ("scrolledwindow") as ScrolledWindow;
            window.show_all ();
        } catch (Error e) {
            print ("Could not load UI: %s\n", e.message);
            return true;
        } 

        scrolled_window.add (this.web_view);

        return false;
    }

    private void exit() {
        try {
            GLib.Process.spawn_command_line_async("killall start.sh");
            GLib.Process.spawn_command_line_async("killall node");
        } catch (GLib.SpawnError e) {
            print("Error: %s\n", e.message);
        }
        Gtk.main_quit();
    }

    private void connect_signals () {
        this.window.destroy.connect (exit);

        this.web_view.title_changed.connect ((source, frame, title) => {

        });
        this.web_view.load_committed.connect ((source, frame) => {

        });
    }

    public void start () {
        this.window.show_all ();
        this.web_view.open (Browser.HOME_URL);
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        var browser = new Browser ();
        browser.start ();

        /* run nodejs */
        try {
            GLib.Process.spawn_command_line_async("node ./node/app.js");
            Posix.sleep(2);
        } catch (GLib.SpawnError e) {
            print("Error: %s\n", e.message);
        }
        
        Gtk.main ();

        return 0;
    }
}