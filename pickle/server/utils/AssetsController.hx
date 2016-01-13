package pickle.server.utils;

import pickle.server.mvc.Controller;

import tannus.sys.Path;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class AssetsController extends Controller<Dynamic> {
/* === Instance Methods === */

	/**
	  * initialize
	  */
	override public function init():Void {
		var path:Path = request.path;
		var dir:Path = path.directory;
		var sheetPaths = (app.assetsDisplayPath() + 'styles').toString();
		var scriptPaths = (app.assetsDisplayPath() + 'scripts').toString();

		if (scriptPaths.endsWith( path.sdir )) {
			script( path );
		}
		else if (sheetPaths.endsWith( path.sdir )) {
			styleSheet( path );
		}
		else {
			res.writeln('styles: ' + sheetPaths);
			res.writeln('scripts: ' + scriptPaths);
		}
	}

	/**
	  * serve a stylesheet
	  */
	private function styleSheet(path : Path):Void {
		res.sendFile(app.styleSheetPath( path.name ), 'text/css');
	}

	/**
	  * serve a script
	  */
	private function script(path : Path):Void {
		res.sendFile(app.scriptPath( path.name ));
	}
}
