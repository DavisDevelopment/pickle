package pickle.client.ui;

import tannus.dom.Element;

import pickle.client.ui.*;

class TopBarSide extends Component {
	/* Constructor Function */
	public function new(owner:TopBar, _side:String):Void {
		super();

		bar = owner;
		side = _side;
		el = bar.el.find( 'div.top-bar-$side' );
		list = new List();
		list.selectEl(el.find( 'ul.menu' ));
	}

/* === Instance Methods === */

	/**
	  * add a Button to [this] shit
	  */
	public function addButton(text:String, ?url:String):Element {
		var btn:Element = '<a class="button">$text</a>';
		if (url != null)
			btn.setAttribute('href', url);
		list.addItem( btn );
		return btn;
	}

/* === Instance Fields === */

	private var bar : TopBar;
	private var side : String;
	public var list : List;
}
