import 'sqlite3_js_interop.dart' as sql_interop;
import 'libsimple_flutter.dart' show Sqlite;

class SqliteImpl extends Sqlite {
  SqliteImpl(super.filename) {
    sql_interop.init(filename, 'ct');
  }

  @override
  exec(String sql) async {
    await sql_interop.exec(sql);
  }

  @override
  Future<List> query(String sql) async {
    var rtn = await sql_interop.query(sql);
    return rtn!;
  }
}
