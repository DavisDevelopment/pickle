package pickle.client.ui;

import tannus.dom.Element;
import pickle.client.ui.*;

class List extends Component {
	/* Constructor Function */
	public function new():Void {
		super();
	}

/* === Instance Methods === */

	/**
	  * add an item to [this] List
	  */
	public function addItem(item : Element):Element {
		var li:Element = '<li></li>';
		el.append( li );
		li.append( item );
		return li;
	}
}
