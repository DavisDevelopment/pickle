package pickle.core;

import pickle.server.core.Response;

interface Template<T> {
	/**
	  * execute [this] Template
	  */
	function execute(res:Response, ctx:T):Void;
}
