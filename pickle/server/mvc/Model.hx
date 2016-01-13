package pickle.server.mvc;

import pickle.server.db.*;
import pickle.server.Application;
import pickle.server.core.*;

class Model {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		con = app.db_connect();
	}

/* === Instance Methods === */

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
	public var con : Connection;
}
