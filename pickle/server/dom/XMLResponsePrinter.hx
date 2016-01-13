package pickle.server.dom;

import tannus.xml.Elem;
import tannus.xml.Printer;
import tannus.ds.Stack;
import pickle.server.core.Response;

using tannus.ds.StringUtils;
using tannus.ds.ArrayTools;

class XMLResponsePrinter extends Printer {
	/* Constructor Function */
	public function new(r : Response):Void {
		super();

		res = r;
	}

/* === Instance Methods === */

	/**
	  * write the data
	  */
	override public dynamic function write(s : String):Void {
		res.write( s );
	}

/* === Instance Fields === */

	private var res : Response;
}
