package pickle.server.core;

import pickle.server.Application;
import pickle.server.core.Route;
import pickle.server.core.*;
import pickle.server.mvc.Controller;

import tannus.sys.Path;
import tannus.sys.GlobStar;

class AppRouter {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		routes = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add a new Route
	  */
	public function addRoute(pattern:GlobStar, ctrl:Class<Controller<Dynamic>>):Route {
		var route = new Route(app, pattern, ctrl);
		routes.push( route );
		return route;
	}

	/**
	  * Pick routes
	  */
	public function run():Void {
		for (route in routes) {
			var taken = route.attempt( app.request );
			if ( taken ) {
				return ;
			}
		}
		php.Web.setReturnCode( 404 );
	}

/* === Instance Fields === */

	public var app : Application;
	public var routes : Array<Route>;
}
