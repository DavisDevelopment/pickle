package pickle.core;

import tannus.xml.Elem;
import tannus.xml.Printer;

import pickle.server.core.Response;

class XmlTemplate<T> extends Elem implements Template<T> {
	/* Constructor Function */
	public function new():Void {
		super( 'template' );
	}

/* === Instance Fields === */

	/**
	  * execute [this] Template
	  */
	@:access(tannus.xml.Printer)
	public function execute(res:Response, ctx:T):Void {
		build( ctx );
		
		var p = new Printer();
		p.write = res.write.bind(_);
		p.generate( this );
	}

	/**
	  * set the current build-context
	  */
	public inline function setContext(ctx : T):Void {
		_currCtx = ctx;
	}
	private function _build():Void {
		if (_currCtx != null) {
			build( _currCtx );
		}
		else {
			// throw 'TemplateError: Cannot build from NULL context';
			build( _currCtx );
		}
	}

	/**
	  * build the xml-dom hierarchy based on the given context
	  */
	private function build(context : Null<T>):Void {
		null;
	}

	/**
	  * do stuff just before encoding
	  */
	override private function _pre_print():Void {
		_build();
	}

/* === Instance Fields === */

	private var _currCtx : Null<T> = null;
}
