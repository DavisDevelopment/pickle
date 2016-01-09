package pickle.server.mvc;

import pickle.server.db.*;
import pickle.server.Application;

class Model {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		con = app.db_connect();
	}

/* === Instance Methods === */

/* === Instance Fields === */

	public var app : Application;
	public var con : Connection;
}
