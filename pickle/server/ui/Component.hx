package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class Component extends HTMLElem {
	/* Constructor Function */
	public function new(tag:String, ?par:Elem):Void {
		super(tag, par);
	}

/* === Instance Methods === */

	/**
	  * Get the value of the given attribute, or the provided default
	  */
	public inline function getOr(name:String, defval:String):String {
		return (exists(name) ? get(name) : defval);
	}
}
