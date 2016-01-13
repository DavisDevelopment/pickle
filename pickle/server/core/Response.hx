package pickle.server.core;

import tannus.ds.Object;
import tannus.ds.Obj;
import tannus.sys.Path;
import tannus.sys.Mime;
import tannus.io.ByteArray;
import tannus.http.Url;

import tannus.xml.*;
import pickle.server.dom.XMLResponsePrinter;

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
		_cookies = new Map();
		type = 'text/html';
		status = 200;
	}

/* === Instance Methods === */

	/**
	  * Send [this] Response
	  */
	public function send():Void {
		if ( !sent ) {
			send_preamble();
			if (data.length > 0) {
				var phpData = data.toBytes().getData();
				Lib.print( phpData );
			}
			sent = false;
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
		sent = true;
	}

	/**
	  * send an xml-dom
	  */
	public function sendXml(node : Elem):Void {
		send_preamble();
		writeXml( node );
		sent = true;
	}

	/**
	  * send the response preamble
	  */
	private function send_preamble():Void {
		Web.setReturnCode( status );
		write_cookies();
		headers.set('Content-Type', type);
		for (key in headers.keys()) {
			Web.setHeader(key, headers.get(key));
		}
	}

	/**
	  * send the cookie-data to the client
	  */
	private function write_cookies():Void {
		for (name in _cookies.keys()) {
			var c = _cookies.get( name );
			Web.setCookie(name, c.value, c.expire, c.domain, c.path, c.secure, c.httpOnly);
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
	  * append an xml node-tree
	  */
	public function writeXml(node : Elem):Void {
		var p = new XMLResponsePrinter(this);
		p.generate( node );
	}

	/**
	  * Redirect to a given Url
	  */
	public function redirect(surl : String):Void {
		var url:Url = new Url( surl );
		headers['Location'] = url.toString();
		send_preamble();
		sent = true;
	}

	/**
	  * Add a new cookie to [this] Response
	  */
	public inline function addCookie(name:String, value:String, ?expire:Date, ?domain:String, ?path:String, ?secure:Bool, ?httpOnly:Bool):Void {
		_cookies.set(name, {
			value: value,
			expire: expire,
			domain: domain,
			path: path,
			secure: secure,
			httpOnly: httpOnly
		});
	}

	/**
	  * Delete a Cookie
	  */
	public function deleteCookie(name : String):Bool {
		var had:Bool = app.request.cookies.exists( name );
		if ( !had ) {
			had = _cookies.exists( name );
		}
		if ( had ) {
			_cookies[name] = {
				'value': '',
				'expire': Date.fromTime(Date.now().getTime() - 1300)
			};
		}
		return had;
	}

/* === Instance Fields === */

	public var app : Application;
	public var data : ByteArray;
	public var headers : Map<String, String>;
	private var _cookies : Map<String, CookieDef>;
	public var type : Mime;
	public var status : Int;

	private var redir:Null<String> = null;
	private var sent:Bool = false;
}

typedef CookieDef = {
	value : String,
	?expire : Date,
	?domain : String,
	?path : String,
	?secure : Bool,
	?httpOnly : Bool
};
