package pickle.server.mvc;

import pickle.server.Application;
import pickle.server.core.Route;
import pickle.server.core.*;

import tannus.ds.Obj;
import tannus.io.Ptr;

class Controller <T : Model> {
	/* Constructor Function */
	public function new(rout:Route, req:Request):Void {
		route = rout;
		app = route.app;
	}

/* === Instance Methods === */

	/**
	  * initialize [this] Controller (called on backend only)
	  */
	private function __init():Void {
		init();
	}

	/**
	  * initialize [this] Controller (overridable)
	  */
	public function init():Void {
		null;
	}

	/**
	  * create a View instance
	  */
	public function view(c:Class<View>, ?extraParams:Array<Dynamic>):View {
		var params:Array<Dynamic> = [this];
		if (extraParams != null)
			params = params.concat( extraParams );
		var view:View = Type.createInstance(c, params);
		return view;
	}

	/**
	  * render a View
	  */
	public function renderView(v:View, ctx:Obj):Void {
		v.execute( ctx );
	}

/* === Computed Instance Fields === */

	public var response(get, never):Response;
	private inline function get_response():Response return app.response;
	public var res(get, never):Response;
	private inline function get_res():Response return response;

	public var request(get, never):Request;
	private inline function get_request():Request return app.request;
	public var req(get, never):Request;
	private inline function get_req():Request return app.request;

	public var session(get, never):Session;
	private inline function get_session():Session return app.session;
	public var sess(get, never):Session;
	private inline function get_sess():Session return app.session;

/* === Instance Fields === */

	public var app : Application;
	public var route : Route;
	public var model : T;
}
