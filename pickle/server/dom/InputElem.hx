package pickle.server.dom;

import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;

class InputElem extends Elem {
	/* Constructor Function */
	public function new(type:String, ?parent:Elem):Void {
		super('input', parent);
		set('type', type);
	}

/* === Computed Instance Fields === */

	/* the name of [this] Input */
	public var name(get, set) : String;
	private inline function get_name():String return (exists('name') ? get('name') : '');
	private inline function set_name(v : String):String return set('name', v);

	/* the textual value of [this] Input */
	public var value(get, set) : String;
	private inline function get_value():String return (exists('value')?get('value'):'');
	private inline function set_value(v:String):String return set('value', v);

	/* the placeholder text of [this] Input */
	public var placeholder(get, set) : String;
	private inline function get_placeholder():String return (exists('placeholder')?get('placeholder'):'');
	private inline function set_placeholder(v:String):String return set('placeholder', v);
}
