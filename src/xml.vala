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

/*
 * Various operations with libxml2: Parsing and creating an XML file
 */

using Xml;
using Xml.XPath;
using Gee;

using HMP;
namespace HMP {
    /**
     * Klasse fuer XML-Operationen
     */
    class XML {
        // Line indentation
        protected int indent = 0;
        
        /**
         * Konstrukter
         */
        public XML() {
        	print("Erstelle HMPXml-Klasse\n");
        	// Initialisation, not instantiation since the parser is a static class
        	Parser.init ();
        	// Beispiel
    		//string simple_xml = HMPXml.create_simple_xml ();
    		//print ("Simple XML is:\n%s\n", simple_xml);
        }
        
        /**
         * Dekonstrukter
         */
        ~XML() {
    		// Do the parser cleanup to free the used memory
    		Parser.cleanup ();
        }

    	/**
    	 * Gibt einen Wert der XML aus
    	 * @param node Nodename
    	 * @param content Wert vom Nodename
    	 * @param token Wert der der Ausgabe vorangestellt wird
    	 */
        protected void print_indent (string node, string content, char token = '+') {
            string indent = string.nfill (this.indent * 2, ' ');
            print ("%s%c%s: %s\n", indent, token, node, content);
        }
    }
}