package pickle.server.db;

import pickle.server.db.*;

@:access( pickle.server.db.Table )
class Query<T> {
	/* Constructor Function */
	public function new(t : Table):Void {
		table = t;
	}

/* === Instance Methods === */

	/**
	  * Generate the SQL code for [this] query
	  */
	private function genSql():String {
		throw 'not implemented';
		return '';
	}

	/**
	  * perform [this] Query
	  */
	public function get():ResultSet<T> {
		return table.con.query(genSql());
	}

/* === Instance Fields === */

	private var table : Table;
}
