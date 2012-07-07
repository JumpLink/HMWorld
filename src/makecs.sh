#!/bin/bash

valac --thread --pkg gio-2.0 server.vala
valac --thread --pkg gio-2.0 client.vala
