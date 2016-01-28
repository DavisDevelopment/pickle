package pickle.server.dom;

import tannus.ds.Obj;
import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class HTMLElem extends Elem {
	/* Constructor Function */
	public function new(type:String, ?par:Elem):Void {
		super(type, par);

		styles = {};
	}

/* === Instance Methods === */

	/**
	  * Apply some dope-ass css styles to [this] Elem
	  */
	public function css(props : Obj):Void {
		for (name in props.keys()) {
			styles[name] = props[name];
		}
	}

	/**
	  * Get the class-list
	  */
	public function classList(?list : Array<String>):Array<String> {
		if (list == null) {
			var slist:Null<String> = get('class');
			if (slist == null) {
				return [];
			}
			else {
				return slist.split(' ');
			}
		}
		else {
			set('class', list.join(' '));
			return list.copy();
		}
	}

	/**
	  * Add a class to the list
	  */
	public function addClass(name : String):Void {
		var list = classList();
		if (!list.has( name ))
			list.push( name );
		classList( list );
	}

	/**
	  * Add a list of classes
	  */
	public function addClasses(set : Array<String>):Void {
		var list = classList();
		for (c in set)
			if (!list.has( c ))
				list.push( c );
		classList( list );
	}

	/**
	  * remove a class from the list
	  */
	public function removeClass(name : String):Bool {
		var list = classList();
		var had = list.remove( name );
		classList( list );
		return had;
	}

	/**
	  * preprocess [this] Elem
	  */
	override private function _pre_print():Void {
		set('style', cssEncode(styles));
	}

	/**
	  * encode an object into a css-string
	  */
	private function cssEncode(o : Obj):String {
		var s = '';
		for (name in o.keys()) {
			s += '$name: ${o[name]}; ';
		}
		return s;
	}

/* === Instance Fields === */

	public var styles : Obj;
}
