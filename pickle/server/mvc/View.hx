package pickle.server.mvc;

import pickle.server.Application;
import pickle.server.core.Route;
import pickle.server.core.Request;
import pickle.server.core.Response;

import tannus.ds.Obj;
import tannus.io.Ptr;
import tannus.io.ByteArray;

class View {
	/* Constructor Function */
	public function new(c:Controller):Void {
		ctrl = c;
	}

/* === Instance Methods === */

	/**
	  * Execute [this] View
	  */
	public function execute(ctx : Obj):Void {
		null;
	}

/* === Computed Instance Fields === */

	/* the application [this] is associated with */
	public var app(get, never):Application;
	private inline function get_app():Application return ctrl.app;

	public var request(get, never):Request;
	private inline function get_request():Request return ctrl.request;

	public var response(get, never):Response;
	private inline function get_response():Response return ctrl.response;
	public var res(get, never):Response;
	private inline function get_res():Response return ctrl.response;

	public var route(get, never):Route;
	private inline function get_route():Route return ctrl.route;

/* === Instance Fields === */

	public var ctrl : Controller;
}
