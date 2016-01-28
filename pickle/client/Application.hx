package pickle.client;

import tannus.io.Ptr;
import tannus.io.Signal;
import tannus.ds.Obj;
import tannus.http.Url;
import tannus.sys.Path;
import tannus.sys.GlobStar;
import tannus.html.Win;

import pickle.client.core.*;
import pickle.client.mvc.*;

import js.Lib;
import js.html.Document;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class Application {
	/* Constructor Function */
	public function new():Void {
		win = Win.current;
		doc = win.document;
		url = new Url( win.location.href );
		router = new AppRouter( this );
		base_path = '';

		doc.onreadystatechange = _readyStateChange;
		win.expose('app', this);
	}

/* === Instance Fields === */

	/**
	  * Start [this] Application
	  */
	@:final
	public function start():Void {
		run();

		router.run();
	}

	/**
	  * Run [this] Application
	  */
	public function run():Void {
		null;
	}

	/**
	  * Add a Route to [this] App
	  */
	public inline function route(pattern:String, ctrl:Class<Controller>):AppRoute {
		return router.addRoute(new GlobStar(pattern), ctrl);
	}

	/**
	  * Invoked when the Document is ready
	  */
	private function _readyStateChange(event : Dynamic):Void {
		if (doc.readyState == 'complete') {
			start();
		}
	}

/* === Instance Methods === */

	/* the current request path */
	public var path(get, never):Path;
	private inline function get_path():Path {
		return new Path(url.pathname.replace(base_path, ''));
	}

/* === Instance Fields === */

	public var win : Win;
	public var doc : Document;
	public var url : Url;

	public var base_path : Path;

	private var router : AppRouter;
}
