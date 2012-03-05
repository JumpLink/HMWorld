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
using Gee;

/**
 * Klasse fuer XML-Operationen
 */
class HMPXml {
    // Line indentation
    private int indent = 0;
    
    /**
     * Konstrukter
     */
    public HMPXml() {
    	//print("Erstelle HMPXml-Klasse\n");
    	// Initialisation, not instantiation since the parser is a static class
    	Parser.init ();
    	
    	// Beispiel
		//string simple_xml = HMPXml.create_simple_xml ();
		//print ("Simple XML is:\n%s\n", simple_xml);
    }
    
    /**
     * Dekonstrukter
     */
    ~HMPXml() {
     	//print("Loesche HMPXml-Klasse\n");
		// Do the parser cleanup to free the used memory
		Parser.cleanup ();
    }

	/**
	 * Gibt einen Wert der XML aus
	 * @param node Nodename
	 * @param content Wert vom Nodename
	 * @param token Wert der der Ausgabe vorangestellt wird
	 */
    private void print_indent (string node, string content, char token = '+') {
        string indent = string.nfill (this.indent * 2, ' ');
        print ("%s%c%s: %s\n", indent, token, node, content);
    }
    
	/**
	 * Läd die Werte einer TileSet-XML.tsx
	 * 
	 * @param path Pfad mit Dateiname der auszulesenden XML
	 * @return struct TileSet.Data mit den gespeicherten Werten
	 */
    public TileSet.Data getTileSetDataFromFile (string path) {
    	//print("\tFuehre getTileSetDataFromFile aus\n");
    	
		TileSet.Data data = TileSet.Data();
    	Gee.HashMap<string, string> tileset_global_properties = new Gee.HashMap<string, string>();
    	Gee.HashMap<string, string> tileset_image_properties = new Gee.HashMap<string, string>();
		
    	parse_file (path, tileset_global_properties, tileset_image_properties);
    	
    	/* Ausgabe der Werte der Maps
    	foreach (var entry in tileset_global_properties.entries) {
        	print ("%s => %s\n", entry.key, entry.value);
    	}
    	foreach (var entry in tileset_image_properties.entries) {
        	print ("%s => %s\n", entry.key, entry.value);
    	}
    	*/
    	
    	// Zuweisung der geparsten Werte
    	data.name = (string) tileset_global_properties.get ("name");
    	data.tilewidth = (uint) tileset_global_properties.get ("tilewidth").to_int();
    	data.tileheight = (uint) tileset_global_properties.get ("tileheight").to_int();
    	
    	data.source = (string) tileset_image_properties.get ("source");
    	data.trans = (string) tileset_image_properties.get ("trans");
    	data.width = (uint) tileset_image_properties.get ("width").to_int();
    	data.height = (uint) tileset_image_properties.get ("height").to_int();
    	
    	return data;
    }

	/**
	 * Läd die Werte einer SpriteSet-XML
	 * 
	 * @param path Pfad mit Dateiname der auszulesenden XML
	 * @return struct SpriteSet.Data mit den gespeicherten Werten
	 */
    public SpriteSet.Data getSpriteSetDataFromFile (string path) {
		SpriteSet.Data data = SpriteSet.Data();
		//parse_file (path, ...);
    	
    	return data;
    }

	/**
	 * Läd die Werte einer Map-XML
	 * 
	 * @param path Pfad mit Dateiname der auszulesenden XML
	 * @return struct Map.Data mit den gespeicherten Werten
	 */
    public Map.Data getMapDataFromFile  (string path) {
		Map.Data data = Map.Data();
		/*data.name = "test";
		parse_file (path, ...);
    	*/
    	return data;
    }

	/**
	 * Hilfsfunktion welche eine XML auslesen kann
	 */
    private void parse_file (string path, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
    	//print("\tbeginne Datei zu parsen\n");
        // Parse the document from path
        Xml.Doc* doc = Parser.parse_file (path);
        if (doc == null) {
            error ("File %s not found or permissions missing", path);
            return;
        }

        // Get the root node. notice the dereferencing operator -> instead of .
        Xml.Node* root = doc->get_root_element ();
        if (root == null) {
            // Free the document manually before returning
            delete doc;
            print ("The xml file '%s' is empty", path);
            return;
        }

        print_indent ("XML document", path, '-');

        // Print the root node's name
        print_indent ("Root node", root->name);
        
    	// Prüfe ob root bereits eines der gesuchten Nodes beinhaltet
		switch (root->name) {
			case "tileset":
				//print("\t%s in root gefunden\n",root->name);
				parse_properties (root, tileset_global_properties);
			break;
			case "image":
				//print("\t%s in root gefunden\n",root->name);
				parse_properties (root, tileset_image_properties);
			break;
			default:
				print("Keine passende Node gefunden!\n");
			break;
		}
        
        // Let's parse those nodes
        parse_node (root, tileset_global_properties, tileset_image_properties);

        // Free the document
        delete doc;
    }

	/**
	 * 
	 */
    private void parse_node (Xml.Node* node, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
    	//print("\tbeginne Node zu parsen\n");
        this.indent++;
        // Loop over the passed node's children
        for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
            // Spaces between tags are also nodes, discard them
            if (iter->type != ElementType.ELEMENT_NODE) {
                continue;
            }

            // Get the node's name
            string node_name = iter->name;
            // Get the node's content with <tags> stripped
            string node_content = iter->get_content ();
            print_indent (node_name, node_content);
		    
			// Prüfe ob node eines der gesuchten Nodes beinhaltet
			switch (iter->name) {
				case "tileset":
					//print("\t%s in node gefunden\n",iter->name);
					parse_properties (iter, tileset_global_properties);
				break;
				case "image":
					//print("\t%s in node gefunden\n",iter->name);
					parse_properties (iter, tileset_image_properties);
				break;
				default:
					print("\tKeine (weiteren) passende Nodes gefunden!\n");
				break;
			}
        
            // Followed by its children nodes
            parse_node (iter, tileset_global_properties, tileset_image_properties);
        }
        this.indent--;
    }

	/**
	 * 
	 */
    private void parse_properties (Xml.Node* node, Gee.HashMap<string, string> properties) {
    	//print("\tbeginne Werte zu parsen\n");
    	bool found = false;
        // Loop over the passed node's properties (attributes)
        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next) {
            string attr_name = prop->name;
            // Notice the ->children which points to a Node*
            // (Attr doesn't feature content)
            string attr_content = prop->children->content;

			print_indent (attr_name, attr_content, '|');
			properties.set(attr_name, attr_content);
        }
    }

	/**
	 * Erzeugt eine Beispiel-XML
	 */
    public static string create_simple_xml () {
        Xml.Doc* doc = new Xml.Doc ("1.0");

        Xml.Ns* ns = new Xml.Ns (null, "", "foo");
        ns->type = Xml.ElementType.ELEMENT_NODE;
        Xml.Node* root = new Xml.Node (ns, "simple");
        doc->set_root_element (root);

        root->new_prop ("property", "value");

        Xml.Node* subnode = root->new_text_child (ns, "subnode", "");
        subnode->new_text_child (ns, "textchild", "another text" );
        subnode->new_prop ("subprop", "escaping \" and  < and >" );

        Xml.Node* comment = new Xml.Node.comment ("This is a comment");
        root->add_child (comment);

        string xmlstr;
        // This throws a compiler warning, see bug 547364
        doc->dump_memory (out xmlstr);

        delete doc;
        return xmlstr;
    }
}
