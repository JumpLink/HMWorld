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
    
    // Um die Werte aus der XML zu speichern
    Gee.HashMap<string, Gee.HashMap<string, string>> nodes;
    Gee.HashMap<string, string>[] properties;
     
    
    /**
     * Konstrukter
     */
    public HMPXml() {
    	// Initialisation, not instantiation since the parser is a static class
    	Parser.init ();
    	
    	// Beispiel
		string simple_xml = HMPXml.create_simple_xml ();
		print ("Simple XML is:\n%s\n", simple_xml);
    }
    
    /**
     * Dekonstrukter
     */
     ~HMPXml() {
		// Do the parser cleanup to free the used memory
		Parser.cleanup ();
    }

	/**
	 * 
	 */
    private void print_indent (string node, string content, char token = '+') {
        string indent = string.nfill (this.indent * 2, ' ');
        print ("%s%c%s: %s\n", indent, token, node, content);
    }
    
	/**
	 * 
	 */
    public TileSet.Data getTileSetDataFromFile (string path) {
		TileSet.Data data = TileSet.Data();
    	properties = new Gee.HashMap<string, string>[2];
		nodes = new Gee.HashMap<string, Gee.HashMap<string, string>>();
    	nodes.set ("tileset", properties[0]);
    	nodes.set ("image", properties[1]);

		
     	nodes.get("tileset").set ("name", "");
    	nodes.get("tileset").set ("tilewidth", "");
    	nodes.get("tileset").set ("tileheight", "");
    	
    	nodes.get("image").set ("source", "");
    	nodes.get("image").set ("trans", "");
    	nodes.get("image").set ("width", "");
    	nodes.get("image").set ("height", "");

    	parse_file (path);
    	
    	data.name = nodes.get("tileset").get ("name");
    	data.tilewidth = (uint) nodes.get("tileset").get ("tilewidth");
    	data.tileheight = (uint) nodes.get("tileset").get ("tileheight");
    	data.source = nodes.get("tileset").get ("source");
    	data.trans = nodes.get("tileset").get ("trans");
    	data.width = (uint) nodes.get("tileset").get ("width");
    	data.height = (uint) nodes.get("tileset").get ("height");
    	
    	return data;
    }

	/**
	 * 
	 */
    public SpriteSet.Data getSpriteSetDataFromFile (string path) {
		SpriteSet.Data data = SpriteSet.Data();
		//data.name = "test";
		parse_file (path);
    	
    	return data;
    }

	/**
	 * 
	 */
    public Map.Data getMapDataFromFile  (string path) {
		Map.Data data = Map.Data();
		data.name = "test";
		parse_file (path);
    	
    	return data;
    }

	/**
	 * 
	 */
    private void parse_file (string path) {
        // Parse the document from path
        Xml.Doc* doc = Parser.parse_file (path);
        if (doc == null) {
            print ("File %s not found or permissions missing", path);
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
        
        foreach (string key in nodes.keys) {
        	// Prüfe ob root bereits eines der gesuchten Nodes beinhaltet
			if (root->name == key) {
				// root beinhaltet eines der gesuchten Nodes, lese dessen properties aus
				parse_properties (root, key);
			}
        }
        
        // Let's parse those nodes
        parse_node (root);

        // Free the document
        delete doc;
    }

	/**
	 * 
	 */
    private void parse_node (Xml.Node* node) {
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
		    
		    foreach (string key in nodes.keys) {
		    	// Prüfe ob root bereits eines der gesuchten Nodes beinhaltet
				if (node->name == key) {
					// root beinhaltet eines der gesuchten Nodes, lese dessen properties aus
					parse_properties (node, key);
				}
		    }
        
            // Followed by its children nodes
            parse_node (iter);
        }
        this.indent--;
    }

	/**
	 * 
	 */
    private void parse_properties (Xml.Node* node, string nodename) {
        // Loop over the passed node's properties (attributes)
        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next) {
            string attr_name = prop->name;
            // Notice the ->children which points to a Node*
            // (Attr doesn't feature content)
            string attr_content = prop->children->content;

			// ist eines der gesuchten Werte im Node enthalten, prüfe mit jedem
			foreach (string k in nodes.get(nodename).keys) {
				// ein propertie enthalten, speichere es
				if (k == attr_name) {
					nodes.get(nodename)[k] = (prop->children->content).to_string ();
				}
			}
		
            print_indent (attr_name, attr_content, '|');
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
