package pickle.client.ui;

import tannus.dom.Element;

import tannus.io.EventDispatcher;

class Component extends EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		super();
	}

/* === Instance Methods === */

	/**
	  * Get [el] from the given String
	  */
	public function selectEl(ctx : Dynamic):Void {
		var elem:Element = new Element( ctx );
		el = elem.at( 0 );
	}

/* === Instance Fields === */

	public var el : Null<Element>;
}
