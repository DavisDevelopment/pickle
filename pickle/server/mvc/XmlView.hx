package pickle.server.mvc;

import pickle.server.Application;
import pickle.server.core.Route;
import pickle.server.core.Request;

import tannus.ds.Obj;
import tannus.io.Ptr;
import tannus.io.ByteArray;
import tannus.xml.Elem;

class XmlView extends View {
	/**
	  * execute [this] View
	  */
	override public function execute(ctx : Obj):Void {
		var tree = buildTree( ctx );
		res.writeXml( tree );
	}

	/**
	  * generate the XML tree
	  */
	public function buildTree(ctx : Obj):Elem {
		return new Elem('xml');
	}
}
