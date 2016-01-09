package pickle.server;

import php.Lib;
import php.Web in NWeb;

import tannus.http.Url;
import tannus.xml.Elem;
import tannus.sys.Path;
import tannus.sys.GlobStar;

import pickle.server.Web;
import pickle.server.core.Route;
import pickle.server.db.Mysql;
import pickle.server.db.*;
import pickle.server.core.*;
import pickle.server.mvc.*;

class Application {
	/* Constructor Function */
	public function new():Void {
		router = new AppRouter( this );

		__gatherData();
	}

/* === Instance Methods === */

	/**
	  * Start [this] Application
	  */
	@:final
	public function start():Void {
		run();
	
		router.run();

		response.send();
	}

	/**
	  * Do the stuff
	  */
	public function run():Void {
		return ;
	}

	/**
	  * Add a route to [this] Application
	  */
	public function route(pattern:String, ctrl:Class<Controller>):Route {
		var gs = GlobStar.fromString( pattern );
		return router.addRoute(gs, ctrl);
	}

	/**
	  * Gather data about the current execution context
	  */
	private function __gatherData():Void {
		db_info = {
			'host': '',
		    	'user': 'root',
		    	'pass': '',
		    	'database': ''
		};
		base_path = '';
		cli = Lib.isCli();
		request = new Request( this );
		response = new Response( this );
	}

	/**
	  * print stuff out to the client
	  */
	public inline function echo(what : String):Void {
		Lib.print( what );
	}

	/**
	  * print the contents of a File out to the client
	  */
	public function echoFile(path : Path):Void {
		try {
			Lib.printFile(path.toString());
		}
		catch (err : Dynamic) {
			echo('Could not read file "$path"');
		}
	}

	/**
	  * print an XML-tree out
	  */
	public function echoXml(el:Elem, ?doctype:String):Void {
		echo(el.print( true ));
	}

	/**
	  * get the path to the assets directory
	  */
	public inline function assetsPath():Path {
		return new Path(cwd + 'assets');
	}

	/**
	  * get the display-path to the assets directory
	  */
	public inline function assetsDisplayPath():Path {
		return (base + 'assets');
	}

	/**
	  * the the path to the scripts directory
	  */
	public function scriptPath(?script : String):Path {
		if (script == null) {
			return (assetsPath() + 'scripts');
		}
		else {
			return (scriptPath() + script);
		}
	}

	/**
	  * the path to the styles directory
	  */
	public inline function styleSheetPath(?sheet : String):Path {
		return (sheet == null ? (assetsPath() + 'styles') : (styleSheetPath() + sheet));
	}

	/**
	  * obtain a database connection
	  */
	public inline function db_connect():Connection {
		return Mysql.connect( db_info );
	}

/* === Computed Instance Fields === */

	/* The current working directory of [this] Script */
	public var cwd(get, never):Path;
	private inline function get_cwd():Path {
		return new Path(NWeb.getCwd());
	}

	/* the base display-path of [this] App */
	public var base(get, never):Path;
	private function get_base():Path {
		var bp = new Path(base_path);
		bp = bp.absolutize();
		return bp;
	}

/* === Instance Fields === */

	/* whether [this] app is in command-line mode */
	public var cli : Bool;

	/* the request in question */
	public var request : Request;

	/* the response to be sent */
	public var response : Response;

	/* the base-path of [this] Application */
	public var base_path : String;

	/* the Router in use by [this] App */
	public var router : AppRouter;

	/* the mysql-connection params */
	public var db_info : Params;
}
