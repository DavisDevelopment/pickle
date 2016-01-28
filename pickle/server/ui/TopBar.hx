package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class TopBar extends Component {
	/* Constructor Function */
	public function new():Void {
		super( 'div' );

		addClass( 'top-bar' );

		left = new TopBarSide(this, 'left');
		right = new TopBarSide(this, 'right');
	}

/* === Instance Fields === */

	public var left : TopBarSide;
	public var right : TopBarSide;
}
