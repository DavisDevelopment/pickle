package pickle.server.db;

import pickle.server.db.Connection;

class Mysql {
	public static function connect(params : Params):Connection {
		return new Connection(sys.db.Mysql.connect(cast params), params);
	}
}
