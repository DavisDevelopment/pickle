package pickle.server;

import php.Lib;
import php.Web in NWeb;

import tannus.ds.QueryString in Qs;
import tannus.ds.Object;
import tannus.ds.Obj;

class Web {
/* === Static Methods === */

/* === Static Fields === */

	/**
	  * The http-method of the current request
	  */
	public static var method(get, never):String;
	private static inline function get_method():String {
		return NWeb.getMethod();
	}

	/**
	  * The current GET-query
	  */
	public static var params(get, never):Obj;
	public static function get_params():Obj {
		if (_params == null) {
			var sdata:String = NWeb.getParamsString();
			var data:Object = Qs.parse( sdata );
			return (_params = Obj.fromDynamic( data ));
		}
		else {
			return _params;
		}
	}

	/**
	  * The current URL of the request
	  */
	public static var url(get, never):String;
	private static inline function get_url():String {
		return NWeb.getURI();
	}

	/**
	  * Whether we're in command-line mode
	  */
	public static var cli(get, never):Bool;
	private static inline function get_cli():Bool return Lib.isCli();

/* === Private Static Fields === */

	/* the variable which stores the GET-query, once decoded */
	private static var _params:Null<Obj> = null;
}
