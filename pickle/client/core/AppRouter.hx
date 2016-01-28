package pickle.client.core;

import pickle.client.Application;
import pickle.client.core.*;
import pickle.client.mvc.Controller;

import tannus.sys.GlobStar;

class AppRouter {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		routes = new Array();
	}

/* === Instance Methods === */

	/**
	  * Find all valid routes
	  */
	public function run():Void {
		for (r in routes) {
			if (r.test()) {
				r.take();
			}
		}
	}

	/**
	  * add a Route to [this]
	  */
	public function addRoute(pattern:GlobStar, controller:Class<Controller>):AppRoute {
		var route = new AppRoute(app, pattern, controller);
		routes.push( route );
		return route;
	}

/* === Instance Fields === */

	private var app : Application;
	private var routes : Array<AppRoute>;
}
