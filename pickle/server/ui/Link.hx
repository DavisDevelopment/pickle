package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;
import tannus.http.Url;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class Link extends Component {
	/* Constructor Function */
	public function new(txt:String, ?url:String):Void {
		super( 'a' );

		text = txt;
		if (url != null)
			href = url;
	}

/* === Computed Instance Fields === */

	/* the 'href' attribute of [this] Link */
	public var href(get, set):String;
	private inline function get_href():String return getOr('href', '');
	private inline function set_href(v : String):String return set('href', v);
}
