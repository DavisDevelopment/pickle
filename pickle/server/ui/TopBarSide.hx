package pickle.server.ui;

import pickle.server.dom.*;

import tannus.xml.Elem;
import tannus.ds.Obj;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class TopBarSide extends Component {
	/* Constructor Function */
	public function new(bar:TopBar, side:String):Void {
		super('div', bar);

		addClass( 'top-bar-$side' );
		items = new List();
		items.addClasses(['dropdown', 'menu']);
		items.set('data-dropdown-menu', 'yes');
		addChild( items );
	}

/* === Instance Methods === */

	/**
	  * append a menu-item to [this]
	  */
	public function addItem(item:HTMLElem, ?classes:Array<String>, ?attrs:Obj):HTMLElem {
		var li = items.addItem( item );
		
		if (classes != null) {
			li.addClasses( classes );
		}
		
		if (attrs != null) {
			li.attr(attrs.toDyn());
		}

		return li;
	}

	/**
	  * add a hyperlink menu-item to [this]
	  */
	public function addLink(text:String, ?href:String):Link {
		var lnk = new Link(text, href);
		addItem( lnk );
		return lnk;
	}

	/**
	  * add a dropdown menu-item to [this]
	  */
	public function addDropdown(text : String):Menu {
		var btn = new Link(text, '#');
		var menu = new Menu();
		var li = addItem( menu );
		li.prepend( btn );
		li.addClass( 'has-submenu' );
		menu.addClasses(['submenu', 'vertical']);
		menu.set('data-submenu', 'yes');
		return menu;
	}

/* === Instance Fields === */

	private var items : List;
}
