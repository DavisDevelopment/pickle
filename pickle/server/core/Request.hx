package pickle.server.core;

import tannus.ds.Object;
import tannus.ds.Obj;
import tannus.sys.Path;

import php.Lib;
import php.Web;

import pickle.server.Application;
import pickle.server.Web in Pw;

using tannus.ds.MapTools;
using StringTools;
using tannus.ds.StringUtils;

class Request {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		method = Web.getMethod();
		headers = new Map();

		__gatherData();
	}

/* === Instance Methods === */

	/**
	  * gather information about [this] Request that needs processing
	  */
	private function __gatherData():Void {
		if ( !Pw.cli ) {
			__parseHeaders();
			__parseParams();
		}
		else {
			params = Obj.fromDynamic({});
		}
	}

	/**
	  * parse the Headers sent with [this] Request
	  */
	private function __parseHeaders():Void {
		var data = Web.getClientHeaders();
		for (item in data) {
			headers.set(item.header, item.value);
		}
	}

	/**
	  * parse the parameters of [this] Request
	  */
	private function __parseParams():Void {
		params = Obj.fromDynamic(Web.getParams().toObject());
	}

/* === Computed Instance Fields === */

	/* the path being requested */
	public var path(get, never) : Path;
	private function get_path():Path {
		if ( Pw.cli )
			return new Path('home');
		else
			return new Path(Web.getURI().after( app.base_path ));
	}

/* === Instance Fields === */

	/* the Application that created [this] */
	private var app : Application;

	/* the method is use by [this] request */
	public var method : String;

	/* the headers sent with [this] request */
	public var headers : Map<String, String>;

	/* the GET-parameters of [this] Request */
	public var params : Obj;
}
