package pickle.server.core;

import php.Web;
import php.Lib;
import php.NativeArray;
import php.NativeString;

import pickle.server.Application;
import pickle.server.core.*;
import pickle.server.db.*;

import tannus.ds.Obj;
import tannus.internal.TypeTools.typename;

import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;

using Lambda;
using tannus.ds.ArrayTools;
using StringTools;
using tannus.ds.StringUtils;

class Session {
	/* Constructor Function */
	public function new(owner : Application):Void {
		app = owner;

		obtainSessionRow();
		pullSessionState();
	}

/* === Instance Methods === */

	/**
	  * Get/Set user data, my sha
	  */
	public inline function userdata<T>(name:String, ?value:T):Null<T> {
		return state.userdata(name, value);
	}

	/**
	  * Get/Set flash data
	  */
	public inline function flashdata<T>(name:String, ?value:T):Null<T> {
		return state.flashdata(name, value);
	}

	/**
	  * Remove some user data
	  */
	public inline function removeUserdata(name : String):Bool {
		return state.removeUserdata( name );
	}

	/**
	  * remove some flash-data
	  */
	public inline function removeFlashdata(name : String):Bool {
		return state.removeFlashdata( name );
	}

	/**
	  * remove some data
	  */
	public function remove(name : String):Bool {
		if (state.hasUserdata( name )) {
			return removeUserdata( name );
		}
		else {
			return removeFlashdata( name );
		}
	}

	/**
	  * check for existence of some user-data
	  */
	public inline function hasUserdata(name : String):Bool return state.hasUserdata( name );

	/**
	  * check for existence of some flash-data
	  */
	public inline function hasFlashdata(name : String):Bool return state.hasFlashdata( name );

	/**
	  * check for data, anywhere
	  */
	public inline function has(name : String):Bool return (state.hasUserdata(name) || state.hasFlashdata(name));

	/**
	  * lookup data, anywhere
	  */
	public function get<T>(name : String):Null<T> {
		return (hasUserdata(name) ? state.userdata : state.flashdata)( name );
	}

	/**
	  * set data, anywhere
	  */
	public function set<T>(name:String, value:T):T {
		return (hasFlashdata(name) ? state.flashdata : state.userdata)(name, value);
	}

	/**
	  * obtain the Row object on which [this] Session will be stored
	  */
	private function obtainSessionRow():Void {
		var c:Connection = app.db_connect();
		var sessions:Table = c.table( TABLENAME );
		if (!sessions.exists()) {
			createSessionsTable( c );
		}
		
		row = attemptLoadSession( sessions );
		if (row == null) {
			row = createSession( sessions );
		}
	}

	/**
	  * create the pickle_sessions table in the database
	  */
	private function createSessionsTable(c : Connection):Void {
		var cols:Array<String> = new Array();
		cols.push('id int(11) auto_increment primary key');
		cols.push('sess_ip varchar(45) not null');
		cols.push('sess_data text not null');
		cols.push('sess_timestamp bigint(20) not null');
		cols.push('sess_user_agent mediumtext not null');
		var coltext:String = cols.join(',\n').wrap('(\n', ')\n');
		var sql:String = ('CREATE TABLE $TABLENAME $coltext');

		c.exec( sql );
	}

	/**
	  * search for existing session-row
	  */
	private function attemptLoadSession(sessions : Table):Null<Row> {
		var sess_ids:Null<String> = app.request.cookies[SESSIONCOOKIE];
		var sess_id:Null<Int> = (sess_ids != null ? Std.parseInt(sess_ids) : null);
		
		if (sess_id != null) {
			var sess:Null<Row> = getSessionRowById(sessions, sess_id);
			if (sess != null) {
				var same_ip:Bool = (sess.get('sess_ip') == Web.getClientIP());
				if ( !same_ip ) {
					sess.delete();
					app.response.deleteCookie( SESSIONCOOKIE );
					app.response.status = 403;
					app.response.writeln( 'Forbidden' );

					return null;
				}
				else {
					return sess;
				}
			}
			else {
				app.response.deleteCookie( SESSIONCOOKIE );
				return null;
			}
		}

		/* or, in the event that no session-cookie is present */
		else {
			/* use the client-ip and user-agent-string to search for current sessions */
			var ip:String = Web.getClientIP();
			var user_agent:Null<String> = getUserAgent();
			
			var sess_q = sessions.select( '*' );
			sess_q.where({
				'sess_ip': ip,
				'sess_user_agent': user_agent
			});
			var sess_row:Null<Row> = sess_q.get().row( 0 );
			return sess_row;
		}
	}

	/**
	  * create new session-row
	  */
	private function createSession(sessions : Table):Row {
		var raw_data = {
			'sess_ip': Web.getClientIP(),
			'sess_user_agent': getUserAgent(),
			'sess_timestamp': Math.floor(Date.now().getTime()),
			'sess_data': encode({
				'user'  : {},
				'flash' : {
					'incoming': {},
					'outgoing': {}
				}
			})
		};

		row = sessions.insert( raw_data );
		app.response.addCookie(SESSIONCOOKIE, row.get('id'), null);
		return row;
	}

	/**
	  * copy the object-state of the session onto [this] object
	  */
	private function pullSessionState():Void {
		// (s)ession (d)ata (s)tring
		var sds:String = row.get( 'sess_data' );
		state = new SessionData(cast parse( sds ));
	}

	/**
	  * write updated session-state onto [row]
	  */
	@:allow( pickle.server.Application )
	private function pushSessionState():Void {
		var sds:String = encode(state.toRaw());
		row.update({
			'sess_data': sds,
			'sess_timestamp': Math.floor(Date.now().getTime())
		});

		//var raw = row.clone()
	}

	/**
	  * fetch a session_row by it's id
	  */
	private function getSessionRowById(sessions:Table, id:Int):Null<Row> {
		var q = sessions.select( '*' );
		q.where( 'id = $id' );
		return q.get().row( 0 );
	}

	/**
	  * encode session-data for storage in the database
	  */
	private function encode(data : Dynamic):String {
		var s = new Serializer();
		s.useCache = true;
		s.useEnumIndex = true;
		s.serialize( data );
		return s.toString();
	}

	/**
	  * parse encoded session-data retrieved from the database
	  */
	private function parse(data : String):Dynamic {
		return Unserializer.run( data );
	}

	/**
	  * Obtain the user-agent
	  */
	private function getUserAgent():String {
		var nserver:NativeArray = cast (untyped __php__("$_SERVER"));
		var server:Map<String, Dynamic> = Lib.hashOfAssociativeArray( nserver );
		if (server.exists('HTTP_USER_AGENT')) {
			return Std.string(server.get('HTTP_USER_AGENT'));
		}
		else {
			throw 'Error: Could not obtain user-agent';
			return '';
		}
	}

/* === Instance Fields === */

	private var app : Application;
	private var row : Row;
	private var state : SessionData;

/* === Static Constants === */

	/* === name of database table in which sessions are stored === */
	public static var TABLENAME:String = {
		(Application.TABLEPREFIX + 'sessions');
	};

	/* === default name under which to store the session-id cookie === */
	public static inline var SESSIONCOOKIE:String = 'pkl_sess';

	/* === default expiration time for sessions === */
	public static inline var SESSIONDURATION:Int = (5 * 60);
}

class SessionData {
	/* Constructor Function */
	public inline function new(rsd : RawSessionData):Void {
		user = obj( rsd.user );
		
		flash = {
			incoming: obj( rsd.flash.incoming ),
			outgoing: obj( rsd.flash.outgoing )
		};
	}

/* === Instance Methods === */

	/**
	  * access user-data
	  */
	public function userdata<T>(name:String, ?value:T):Null<T> {
		if (value == null)
			return (user.get( name ));
		else
			return (user.set(name, value));
	}

	/**
	  * remove some user-data
	  */
	public inline function removeUserdata(name : String):Bool {
		return user.remove( name );
	}

	/**
	  * check for existence of some user-data
	  */
	public inline function hasUserdata(name : String):Bool {
		return user.exists( name );
	}

	/**
	  * access flash-data
	  */
	public function flashdata<T>(name:String, ?value:T):Null<T> {
		if (value == null) {
			var stores:Array<Bool> = [flash.incoming.exists(name), flash.outgoing.exists(name)];
			var src = (switch ( stores ) {
				case [true, false]: flash.incoming;
				default: flash.outgoing;

			});
			return src.get( name );
		}
		else {
			return flash.outgoing.set(name, value);
		}
	}

	/**
	  * check for existence of flash-data
	  */
	public inline function hasFlashdata(name : String):Bool {
		return flash.incoming.exists( name );
	}

	/**
	  * remove flash-data
	  */
	public inline function removeFlashdata(name : String):Bool {
		return flash.outgoing.remove( name );
	}

	/**
	  * keep some flash-data until the next request
	  */
	public function keepFlashdata(name : String):Void {
		if (flash.incoming.exists(name)) {
			flash.outgoing.set(name, flash.incoming.get(name));
		}
	}

	/**
	  * back to raw form 
	  */
	public function toRaw():RawSessionData {
		var res:RawSessionData = {
			'user'  : user.toDyn(),
			'flash' : {
				'incoming': flash.outgoing.toDyn(),
				'outgoing': {}
			}
		};
		return res;
	}

/* === Instance Fields === */

	private var user : Obj;
	private var flash : {incoming:Obj, outgoing:Obj};

	/* shorthand for Obj creation */
	private static inline function obj(x : Dynamic):Obj return Obj.fromDynamic(x);
}

typedef RawSessionData = {
	var user : Dynamic;
	var flash : {
		incoming : Dynamic,
		outgoing : Dynamic
	};
};

/*
typedef ObjSessionData = {
	var user : Obj;
	var flash : {
		incoming : Dynamic,
		outgoing : Dynamic
	};
};
*/
