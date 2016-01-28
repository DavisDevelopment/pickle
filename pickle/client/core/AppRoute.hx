package pickle.client.core;

import pickle.client.Application;
import pickle.client.core.*;
import pickle.client.mvc.*;

import tannus.sys.GlobStar;
import tannus.ds.Obj;

import Type.*;
import haxe.rtti.Meta;

class AppRoute {
	/* Constructor Function */
	public function new(owner:Application, gs:GlobStar, ctrl:Class<Controller>):Void {
		app = owner;
		pattern = gs;
		controller = ctrl;
	}

/* === Instance Methods === */

	/**
	  * Check for a match with the current Url
	  */
	public inline function test():Bool {
		return pattern.test(app.path);
	}

	/**
	  * 'take' [this] Route
	  */
	public function take():Void {
		data = Obj.fromDynamic(pattern.match(app.path));
		var ctrl:Controller = createController();
		ctrl.init( data );
	}

	/**
	  * build the Controller instance
	  */
	private inline function createController():Controller {
		return createInstance(controller, [app]);
	}

/* === Instance Fields === */

	public var app : Application;
	public var controller : Class<Controller>;
	public var pattern : GlobStar;

	public var data : Obj;
}
