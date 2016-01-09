package pickle.server.core;

import pickle.server.Application;
import pickle.server.core.*;
import pickle.server.mvc.Controller;

import tannus.sys.Path;
import tannus.sys.GlobStar;
import tannus.ds.Obj;

class Route {
	/* Constructor Function */
	public function new(owner:Application, gs:GlobStar, c:Class<Controller>):Void {
		app = owner;
		pattern = gs;
		controller = c;
	}

/* === Instance Methods === */

	/**
	  * Check if the given Request validates against [this] Route
	  */
	public function test(req : Request):Bool {
		return pattern.test( req.path );
	}

	/**
	  * 'take' [this] Route
	  */
	public function take(req : Request):Void {
		var rd = pattern.match(req.path.toString());
		if (rd != null)
			data = Obj.fromDynamic( rd );
		create( req );
	}

	/**
	  * attempt to take [this] Route
	  */
	public function attempt(req : Request):Bool {
		if (test( req )) {
			take( req );
			return true;
		}
		else {
			return false;
		}
	}

	/**
	  * Instantiate and boot the Controller
	  */
	@:access( pickle.server.mvc.Controller )
	private function create(req : Request):Void {
		var ctrl:Controller = Type.createInstance(controller, untyped [this, req]);
		ctrl.__init();
	}

/* === Instance Fields === */

	public var app : Application;
	public var pattern : GlobStar;
	public var controller : Class<Controller>;

	public var data : Null<Obj> = null;
}
