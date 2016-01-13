package pickle.server.db;

import sys.db.ResultSet in Results;

using Lambda;
using tannus.ds.ArrayTools;

@:forward
abstract ResultSet (CResultSet) to CResultSet {
	/* Constructor Function */
	public inline function new(t:Table, c:Results):Void {
		this = new CResultSet(t, c);
	}

	@:arrayAccess
	public inline function row(i : Int):Row return this.row( i );
}

class CResultSet {
	/* Constructor Function */
	public function new(t:Table, res:Results):Void {
		src = res;
		table = t;
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
	public function next():Row {
		return new Row(table, src.next());
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
	public function results():Array<Row> {
		if (_all == null) {
			_all = cast src.results().array().macmap(new Row(table, _));
		}
		return _all;
	}

	/**
	  * get the row at the given index
	  */
	public inline function row(index : Int):Row {
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
	private var table : Table;
	private var _all : Null<Array<Row>> = null;
}
