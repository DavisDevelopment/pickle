package pickle.server.db;

import sys.db.ResultSet in Results;

using Lambda;

@:forward
abstract ResultSet<T> (CResultSet<T>) from CResultSet<T> to CResultSet<T> {
	/* Constructor Function */
	public inline function new(c : CResultSet<T>):Void {
		this = c;
	}

	@:arrayAccess
	public inline function row(i : Int):T return this.row( i );

	@:from
	public static function fromResults<T>(r : Results):ResultSet<T> return new CResultSet(r);
}

class CResultSet<T> {
	/* Constructor Function */
	public function new(res : Results):Void {
		src = res;
	}

/* === Instance Methods === */

	/**
	  * Determine whether there is a 'next' value in [this] set
	  */
	public inline function hasNext():Bool {
		return src.hasNext();
	}

	/**
	  * Get the next value in [this] set
	  */
	public function next():T {
		return (untyped src.next());
	}

	/**
	  * Get the float-value (if applicable) at the given index
	  */
	public inline function getFloat(index : Int):Float return src.getFloatResult( index );
	public inline function getInt(index : Int):Int return src.getIntResult( index );
	public inline function get(index : Int):String return src.getResult( index );

	/**
	  * The full array of rows
	  */
	public function results():Array<T> {
		if (_all == null) {
			_all = cast src.results().array();
		}
		return _all;
	}

	/**
	  * get the row at the given index
	  */
	public inline function row(index : Int):T {
		return (results()[index]);
	}

/* === Computed Instance Fields === */

	/* the column-names */
	public var fieldNames(get, never):Null<Array<String>>;
	private inline function get_fieldNames():Null<Array<String>> return src.getFieldsNames();

	/* the length of [this] Result set */
	public var length(get, never):Int;
	private inline function get_length():Int return src.length;

/* === Instance Fields === */

	private var src : Results;
	private var _all : Null<Array<T>> = null;
}
