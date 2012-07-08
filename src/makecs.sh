#!/bin/bash

valac --thread --pkg gio-2.0 --pkg gee-1.0 server.vala
valac --thread --pkg gio-2.0 --pkg gee-1.0 client.vala
