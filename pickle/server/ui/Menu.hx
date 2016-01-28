package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;
import tannus.ds.Obj;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class Menu extends List {
	/* Constructor Function */
	public function new():Void {
		super();

		addClass( 'menu' );
	}

/* === Instance Methods === */

	/**
	  * Add a Button to [this] Menu
	  */
	public function addButton(text:String, url:String='#'):HTMLElem {
		var btn = new Link(text, url);
		var li = addItem( btn );
		return btn;
	}
}
