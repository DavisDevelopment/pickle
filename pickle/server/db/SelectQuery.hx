package pickle.server.db;

import pickle.server.db.*;

import tannus.ds.Obj;

import Std.is;

class SelectQuery extends Query {
	/* Constructor Function */
	public function new(t:Table, s:String):Void {
		super( t );

		sel = s;
		wheres = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add a WHERE clause
	  */
	public function where(clause : Dynamic):SelectQuery {
		if (is(clause, String)) {
			wheres.push(cast clause);
		}
		else {
			var ocl:Obj = Obj.fromDynamic( clause );
			for (col in ocl.keys()) {
				wheres.push('$col = ' + haxe.Json.stringify(ocl.get(col)));
			}
		}
		return this;
	}

	/**
	  * Build the SQL query
	  */
	override private function genSql():String {
		var sql:String = 'SELECT $sel FROM ${table.name}';
		if (wheres.length > 0) {
			sql += ' WHERE ';
			sql += wheres.join(' AND ');
		}
		sql += ';';
		return sql;
	}

/* === Instance Fields === */

	private var sel : String;
	private var wheres : Array<String>;
}
