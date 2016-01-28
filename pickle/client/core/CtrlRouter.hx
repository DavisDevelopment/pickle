package pickle.client.core;

import pickle.client.Application;
import pickle.client.core.*;
import pickle.client.mvc.Controller;

import tannus.sys.GlobStar;
import tannus.ds.Obj;

class CtrlRouter {
	/* Constructor Function */
	public function new(owner : Controller):Void {
		controller = owner;
		routes = new Array();
	}

/* === Instance Methods === */

	/**
	  * Find all valid routes
	  */
	public function run():Void {
		for (r in routes) {
			r.attempt();
		}
	}

	/**
	  * add a Route to [this]
	  */
	public function addRoute(pattern:GlobStar, action:Void->Void):CtrlRoute {
		var route = new CtrlRoute(controller, pattern, action);
		routes.push( route );
		return route;
	}

/* === Instance Fields === */

	private var controller : Controller;
	private var routes : Array<CtrlRoute>;
}
