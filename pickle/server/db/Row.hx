package pickle.server.db;

import pickle.server.db.*;

import tannus.ds.Obj;
import tannus.ds.Delta;

class Row {
	/* Constructor Function */
	public function new(t:Table, rdata:Dynamic):Void {
		table = t;
		row_data = rdata;
		row = Obj.fromDynamic( row_data );
	}

/* === Instance Methods === */

	/**
	  * get the value of a field of [this] Row
	  */
	public inline function get<T>(key : String):Null<T> return row[key];

	/**
	  * set the value of a field of [this] Row
	  */
	public inline function set<T>(key:String, value:T):T return (row[key] = value);

	/**
	  * check for the existence of a field on [this] Row
	  */
	public inline function exists(key : String):Bool return row.exists(key);

	/**
	  * delete a field from [this] Row
	  */
	public inline function remove(key : String):Bool return row.remove(key);

	/**
	  * delete [this] Row
	  */
	public function delete():Void {
		var prim = pkey();
		var id = get( prim );
		table.delete('$prim='+Json.stringify(id));
	}

	/**
	  * get the name of the Table's primary-key
	  */
	public function pkey():String {
		return table.primaryKey().name;
	}

/* === Instance Fields === */

	private var table : Table;
	private var row_data : Dynamic;
	private var row : Obj;
}
