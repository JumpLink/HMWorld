#!/bin/bash

valac --thread --pkg gio-2.0 --pkg gee-1.0 --target-glib=2.32 server.vala
valac --thread --pkg gio-2.0 --pkg gee-1.0 --target-glib=2.32 client.vala
