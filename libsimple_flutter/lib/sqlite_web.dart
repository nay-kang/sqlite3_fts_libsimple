import 'sqlite3_js_interop.dart' as sql_interop;
import 'libsimple_flutter.dart' show Sqlite;

class SqliteImpl extends Sqlite {
  SqliteImpl(super.filename) {
    sql_interop.init(filename, 'ct');
  }

  @override
  exec(String sql, [List bind = const []]) async {
    await sql_interop.exec(sql, bind);
  }

  @override
  Future<List> query(String sql, [List bind = const []]) async {
    var rtn = await sql_interop.query(sql, bind);
    return rtn;
  }
}
