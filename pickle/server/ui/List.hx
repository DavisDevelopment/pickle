package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class List extends Component {
	/* Constructor Function */
	public function new():Void {
		super( 'ul' );

		items = new Array();
	}

/* === Instance Methods === */

	/**
	  *
	  */
	public function addItem(item : Elem):HTMLElem {
		var li = new HTMLElem( 'li' );
		super.append( li );
		items.push( item );
		li.append( item );
		return li;
	}

	/**
	  * add a list-item to [this]
	  */
	override public function append(item : Elem):Void {
		super.append( item );
	}

/* === Instance Fields === */

	public var items : Array<Elem>;
}
