package pickle.client.mvc;

import pickle.client.Application;
import pickle.client.core.*;

import tannus.io.EventDispatcher;
import tannus.ds.Obj;
import tannus.sys.GlobStar;

import Type.*;
import Reflect.*;
import haxe.rtti.Meta;

class Controller extends EventDispatcher {
	/* Constructor Function */
	public function new(owner : Application):Void {
		super();

		app = owner;
		router = new CtrlRouter( this );

		__metaRoutes();
	}

/* === Instance Methods === */

	/**
	  * Initialize [this] Controller
	  */
	public function init(data : Obj):Void {
		open( data );

		router.run();
	}

	/**
	  * Code to run every time
	  */
	public function open(data : Obj):Void {
		null;
	}

	/**
	  * Add a Route to [this]
	  */
	public inline function route(pattern:String, action:Void->Void):CtrlRoute {
		return router.addRoute(new GlobStar(pattern), action);
	}

	/**
	  * bind Routes via metadata
	  */
	private function __metaRoutes():Void {
		var shitCock:Obj = Meta.getFields(getClass(this));
		var self:Obj = this;
		for (methodName in shitCock.keys()) {
			var method:Dynamic = makeVarArgs(callMethod.bind(this, self[methodName], _));
		}
	}


/* === Instance Fields === */

	public var app : Application;
	
	private var router : CtrlRouter;
}
