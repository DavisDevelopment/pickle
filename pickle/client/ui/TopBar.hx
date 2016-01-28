package pickle.client.ui;

import tannus.dom.Element;

import pickle.client.ui.*;

class TopBar extends Component {
	/* Constructor Function */
	public function new(target : Element):Void {
		super();

		el = target;
		left = new TopBarSide(this, 'left');
		right = new TopBarSide(this, 'right');
	}

/* === Instance Fields === */

	public var left : TopBarSide;
	public var right : TopBarSide;
}
