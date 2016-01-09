package pickle.server.dom;

import tannus.xml.Elem;

using StringTools;
using Lambda;
using tannus.ds.ArrayTools;
using tannus.ds.StringUtils;

class ElemTools {
	/**
	  * get the list of 'classes' associated with the given Elem
	  */
	public static function getClassList(e : Elem):Array<String> {
		if (e.exists('class')) {
			var scl:String = e.get('class');
			return scl.split(' ').macfilter(!_.trim().empty());
		}
		else {
			return new Array();
		}
	}

	/**
	  * set the list of 'classes' associated with the given Elem
	  */
	public static function setClassList(e:Elem, list:Array<String>):Array<String> {
		list = list.macfilter(!_.trim().empty());
		e.set('class', list.join(' '));
		return list;
	}

	/**
	  * get/set the list of 'classes' associated with the given Elem
	  */
	public static function classList(e:Elem, ?list:Array<String>):Array<String> {
		if (list == null) {
			return getClassList( e );
		}
		else {
			return setClassList(e, list);
		}
	}

	/**
	  * check whether the given Elem has the given Class
	  */
	public static function hasClass(e:Elem, c:String):Bool {
		return classList( e ).has( c );
	}

	/**
	  * add a class to the given Elem
	  */
	public static function addClass(e:Elem, c:String):Void {
		var cl = classList( e );
		cl.push( c );
		cl = cl.unique();
		classList(e, cl);
	}

	/**
	  * remove a class from the given Elem
	  */
	public static function removeClass(e:Elem, c:String):Void {
		var cl = classList( e );
		cl.remove( c );
		cl = cl.unique();
		classList(e, cl);
	}
}
