package pickle.server.core;

import php.Lib;

import tannus.io.Getter;

import haxe.io.Bytes;
import sys.io.File.getBytes;

import pickle.server.Application;

@:forward
abstract FileManager (CFileManager) from CFileManager to CFileManager {
	/* Constructor Function */
	public inline function new(app : Application):Void {
		this = new CFileManager( app );
	}

/* === Instance Fields === */

	/**
	  * get a File by name
	  */
	@:arrayAccess
	public inline function get(name : String):File {
		return this.get( name );
	}
}

class CFileManager {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		_all = null;
	}

/* === Instance Fields === */

	/**
	  * Get the full list of files
	  */
	public function all():Map<String, File> {
		if (_all == null) {
			if (untyped __call__("isset", untyped __php__("$_FILES"))) {
				var nmap = Lib.hashOfAssociativeArray(untyped __php__("$_FILES"));
				_all = new Map();
				for (name in nmap.keys()) {
					var f = nmap.get( name );
					_all.set(name, {
						'name': untyped __var__(f, 'name'),
						'type': untyped __var__(f, 'type'),
						'size': untyped __var__(f, 'size'),
						'content': function() {
							return getBytes(untyped __var__(f, 'tmp_name'));
						}
					});
				}
				return _all;
			}
			else {
				return (_all = new Map());
			}
		}
		else {
			return _all;
		}
	}

	/**
	  * Get a File by name, or [null] if none exists
	  */
	private function getOrNull(name : String):Null<File> {
		if (_all == null) {
			if (exists( name )) {
				var f = untyped __var__("_FILES", name);
				return {
					'name': untyped __var__(f, 'name'),
					'type': untyped __var__(f, 'type'),
					'size': untyped __var__(f, 'size'),
					'content': function() {
						return getBytes(untyped __var__(f, 'tmp_name'));
					}
				};
			}
			else {
				return null;
			}
		}
		else {
			return _all.get( name );
		}
	}

	/**
	  * Get a File by name
	  */
	public inline function get(name : String):File {
		return getOrNull( name );
	}

	/**
	  * Check whether a given file exists
	  */
	public function exists(name : String):Bool {
		if (_all == null) {
			return (untyped __call__("isset", untyped __var__("_FILES", name)));
		}
		else {
			return _all.exists( name );
		}
	}

	/**
	  * Iterate over all keys of [this]
	  */
	public function names():Iterator<String> {
		return all().keys();
	}

	/**
	  * Iterate over all files
	  */
	public function iterator():Iterator<File> {
		return all().iterator();
	}

/* === Instance Fields === */

	private var _all : Null<Map<String, File>>;
	private var app : Application;
}

typedef File = {
	var name : String;
	var type : String;
	var size : Int;
	var content : Void -> Bytes;
};
