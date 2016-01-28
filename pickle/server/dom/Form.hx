package pickle.server.dom;

import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;

class Form extends Elem {
	/* Constructor Function */
	public function new(?parent : Elem):Void {
		super('form', parent);
	}

/* === Instance Methods === */

	/**
	  * Add an input to [this] Form
	  */
	public function input(type:String='text', ?name:String):InputElem {
		var inp = new InputElem(type, this);
		if (name != null) {
			inp.name = name;
		}
		return inp;
	}

/* === Computed Instance Fields === */

	/* the method employed by [this] Form */
	public var method(get, set):String;
	private inline function get_method():String return (exists('method')?get('method'):set('method', 'GET'));
	private inline function set_method(v:String):String return set('method', v);

	/* the url to submit [this] Form to */
	public var action(get, set):String;
	private inline function get_action():String return (exists('action')?get('action'):'');
	private inline function set_action(v:String):String return set('action', v);

	/* the enc-type of [this] Form */
	public var enctype(get, set):String;
	private inline function get_enctype():String return (exists('enctype')?get('enctype'):'');
	private inline function set_enctype(v : String):String return set('enctype', v);
}
