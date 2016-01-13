package pickle.server.dom;

import tannus.xml.Elem;
import tannus.css.StyleSheet;
import tannus.ds.Memory in Mem;

import pickle.core.XmlTemplate;

class Document extends XmlTemplate<Dynamic> {
	/* Constructor Function */
	public function new():Void {
		super();

		tag = 'html';

		doctype = 'html';
		head = new Elem('head', this);
		body = new Elem('body', this);
	}

/* === Instance Methods === */

	/**
	  * Add a stylesheet to [this] Document
	  */
	public function addStyleSheet(sheet : StyleSheet):Document {
		var style = new Elem('style', head);
		var sid:String = Mem.allocRandomId( 6 );
		style.set('id', sid);
		style.text = sheet.toString();
		sheet.onchange(function() {
			style.text = sheet.toString();
		});
		return this;
	}

	/**
	  * Add a StyleSheet file reference to [this] Document
	  */
	public function addStyleSheetUrl(url : String):Document {
		var link = new Elem('link', head);
		link.attr({
			'rel': 'stylesheet',
			'type': 'text/css',
			'href': url
		});
		return this;
	}

	/**
	  * Add a JavaScript file reference to [this] Document
	  */
	public function addScriptUrl(url : String):Document {
		var script = new Elem('script', head);
		script.attr({
			'type': 'application/javascript',
			'src': url
		});
		return this;
	}

	/**
	  * Output [this] shit as a String
	  */
	override public function print(pretty:Bool=false):String {
		var res:String = '<!DOCTYPE $doctype>\n';
		res += super.print( pretty );
		return res;
	}

/* === Computed Instance Fields === */

	/**
	  * The title of [this] Document
	  */
	public var title(get, set) : String;
	private function get_title():String {
		if (_title != null) {
			return _title.text;
		}
		else {
			return '';
		}
	}
	private function set_title(v : String):String {
		if (_title == null) {
			_title = new Elem('title', head);
		}
		return (_title.text = v);
	}

/* === Instance Fields === */

	/* the 'doctype' of [this] Document */
	public var doctype : String;

	/* the body of [this] Document */
	public var body : Elem;

	/* the head of [this] Document */
	public var head : Elem;

	/* the element which holds the title of [this] Document */
	private var _title : Null<Elem> = null;
}
