package pickle.server.db;

import pickle.server.db.*;

import tannus.ds.Obj;

import haxe.Json;

using StringTools;
using tannus.ds.StringUtils;

class Table {
	/* Constructor Function */
	public function new(c:Connection, tableName:String):Void {
		con = c;
		_name = tableName;
	}

/* === Instance Methods === */

	/**
	  * perform a SELECT query
	  */
	public function select<T>(what : String):SelectQuery<T> {
		return new SelectQuery(this, what);
	}

	/**
	  * perform an INSERT
	  */
	public function insert(row : Obj):ResultSet<Dynamic> {
		var columns:Array<String> = new Array();
		var values:Array<String> = new Array();
		for (col in row.keys()) {
			columns.push( col );
			values.push(Json.stringify(row.get(col)));
		}
		var scols = columns.join(', ').wrap('(', ')');
		var svals = values.join(', ').wrap('(', ')');
		var sql = ('INSERT INTO $name $scols VALUES $svals');
		return con.query( sql );
	}

	/**
	  * perform a DELETE
	  */
	public function delete(where : Dynamic):Void {
		var whereSql:String = compileWhere( where );
		var sql:String = ('DELETE FROM $name ' + whereSql);
		con.query( sql );
	}

	/**
	  * perform an UPDATE
	  */
	public function update(values:Obj, ?where:Dynamic):ResultSet<Dynamic> {
		var sql:String = 'UPDATE $name SET ';
		sql += compileSets(values).join(', ');
		if (where != null)
			sql += (' '+ compileWhere( where ));
		sql += ';';
		return con.query( sql );
	}

	/**
	  * compile an Obj into a list of assignmint
	  */
	private function compileSets(values : Obj):Array<String> {
		var sets:Array<String> = new Array();
		for (col in values.keys()) {
			var encval = Json.stringify(values.get(col));
			sets.push(col + '=' + encval);
		}
		return sets;
	}

	/**
	  * compile a WHERE clause into SQL
	  */
	private function compileWhere(where : Dynamic):String {
		var clauses:Array<String> = new Array();
		if (Std.is(where, String)) {
			clauses.push(cast where);
		}
		else {
			var owhere:Obj = Obj.fromDynamic(where);
			for (cname in owhere.keys()) {
				clauses.push(cname + ' = ' + Json.stringify(owhere[cname]));
			}
		}
		var sql:String = (clauses.length > 0 ? 'WHERE '+clauses.join(' AND ') : '');
		return sql;
	}

	/**
	  * retrieve metadata about [this] Table
	  */
	@:access(pickle.server.db.Connection)
	@:access(pickle.server.db.Query)
	public function getMetaData():TableInfo {
		if (_meta == null) {
			var i = con.info;
			var dbi:Params = {
				'host': i.host,
				'user': i.user,
				'pass': i.pass,
				'database': 'information_schema'
			};
			var icon = Mysql.connect( dbi );
			var keys = ['COLUMN_NAME', 'ORDINAL_POSITION', 'IS_NULLABLE', 'DATA_TYPE', 'COLUMN_KEY'];
			var clauses:Obj = {'TABLE_NAME': name};
			if (i.database != '')
				clauses['TABLE_SCHEMA'] = i.database;
			var colset_q = icon.table('COLUMNS').select(keys.join(', ')).where(clauses.toDyn());
			var colset = colset_q.get();
			icon.close();
			var rawcols:Array<Obj> = [for (c in colset) Obj.fromDynamic( c )];
			
			var info:TableInfo = {
				'columns': new Map()
			};

			for (raw in rawcols) {
				var col:ColInfo = {
					'name': raw['COLUMN_NAME'],
					'type': raw['DATA_TYPE'],
					'pos': raw['ORDINAL_POSITION'],
					'primary': (cast(raw['COLUMN_KEY'], String) == 'PRI'),
					'nullable': switch (cast(raw['IS_NULLABLE'], String).toLowerCase()) {
						case 'yes': true;
						case 'no' : false;
						default: false;
					}
				};
				info.columns[col.name] = col;
			}

			return (_meta = info);
		}
		else {
			return _meta;
		}
	}

	/**
	  * get [this] Table's primary-key info
	  */
	public function primaryKey():Null<ColInfo> {
		// column info
		var ci = getMetaData().columns;
		for (info in ci)
			if ( info.primary )
				return info;
		throw 'WhatTheFuck: primary-key not found';
		return null;
	}

/* === Computed Instance Fields === */

	/* the name of [this] Table */
	public var name(get, never):String;
	private inline function get_name():String return _name;

/* === Instance Fields === */

	private var con : Connection;
	private var _name : String;
	private var _meta : Null<TableInfo> = null;
}

typedef TableInfo = {
	var columns : Map<String, ColInfo>;
};

typedef ColInfo = {
	var name : String;
	var type : String;
	var pos : Int;
	var primary : Bool;
	var nullable : Bool;
};
