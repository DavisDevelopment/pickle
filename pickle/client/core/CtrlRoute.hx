package pickle.client.core;

import pickle.client.mvc.Controller;

import tannus.sys.GlobStar;
import tannus.ds.Obj;

class CtrlRoute {
	/* Constructor Function */
	public function new(c:Controller, gs:GlobStar, f:Void->Void):Void {
		controller = c;
		pattern = gs;
		action = f;
	}

/* === Instance Methods === */

	/**
	  * attempt to take [this] Route
	  */
	public inline function attempt():Void {
		if (test())
			take();
	}

	/**
	  * test whether [this] Route should be taken
	  */
	public inline function test():Bool {
		return pattern.test(controller.app.path);
	}

	/**
	  * take [this] Route
	  */
	public inline function take():Void {
		action();
	}

/* === Instance Fields === */

	public var controller : Controller;
	public var pattern : GlobStar;
	public var action : Void -> Void;
}
