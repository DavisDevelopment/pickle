package pickle.server.db;

import tannus.ds.Object;
import tannus.ds.Obj;
import tannus.io.ByteArray;
import tannus.io.Ptr;

import php.Lib;

import sys.db.Connection in Conn;

using StringTools;
using tannus.ds.StringUtils;

class Connection {
	/* Constructor Function */
	public function new(c:Conn, info:Params):Void {
		cn = c;
		this.info = info;
	}

/* === Instance Methods === */

	/**
	  * get the name of the database we're connected to
	  */
	public inline function dbName():String {
		return cn.dbName();
	}

	/**
	  * perform an SQL query
	  */
	public inline function query<T>(sql : String):ResultSet<T> {
		return cn.request( sql );
	}

	/**
	  * perform a SELECT query
	  */
	public function table(name : String):Table {
		return new Table(this, name);
	}

	/**
	  * close [this] Connection
	  */
	public inline function close():Void {
		cn.close();
	}

/* === Instance Fields === */

	private var cn : Conn;
	private var info : Params;
}
