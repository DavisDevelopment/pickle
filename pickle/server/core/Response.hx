package pickle.server.core;

import tannus.ds.Object;
import tannus.ds.Obj;
import tannus.sys.Path;
import tannus.sys.Mime;
import tannus.io.ByteArray;

import php.Lib;
import php.Web;

import pickle.server.Application;

using tannus.ds.MapTools;
using StringTools;
using tannus.ds.StringUtils;

class Response {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;
		data = new ByteArray();
		headers = new Map();
		type = 'text/html';
		status = 200;
	}

/* === Instance Methods === */

	/**
	  * Send [this] Response
	  */
	public function send():Void {
		send_preamble();
		if (data.length > 0) {
			var phpData = data.toBytes().getData();
			Lib.print( phpData );
		}
	}

	/**
	  * Send the specified file as the response
	  */
	public function sendFile(path:Path, ?mime:Mime):Void {
		if (mime == null) {
			type = tannus.sys.Mimes.getMimeType( path.extension );
		}
		else {
			type = mime;
		}
		send_preamble();
		Lib.printFile(path.toString());
	}

	/**
	  * send the response preamble
	  */
	private function send_preamble():Void {
		Web.setReturnCode( status );
		headers.set('Content-Type', type);
		for (key in headers.keys()) {
			Web.setHeader(key, headers.get(key));
		}
	}

	/**
	  * Append some data to [this] Response
	  */
	public inline function append(b : ByteArray):Void {
		data.append( b );
	}

	/**
	  * Append a String to [this] Response
	  */
	public inline function write(s : String):Void {
		data.appendString( s );
	}

	/**
	  * Append a String, followed by a newline
	  */
	public inline function writeln(s : String):Void {
		write(s + '\n');
	}

	/**
	  * Redirect to a given Url
	  */
	public inline function redirect(url : String):Void {
		Web.redirect( url );
	}

/* === Instance Fields === */

	public var app : Application;
	public var data : ByteArray;
	public var headers : Map<String, String>;
	public var type : Mime;
	public var status : Int;
}
