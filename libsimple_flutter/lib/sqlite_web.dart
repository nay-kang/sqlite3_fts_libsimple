import 'sqlite3_js_interop.dart' show SqliteDart;
import 'libsimple_flutter.dart' show Sqlite;

class SqliteImpl extends Sqlite {
  late SqliteDart dbInstance;
  SqliteImpl(super.filename) {
    dbInstance = SqliteDart(filename);
  }

  @override
  exec(String sql) async {
    await dbInstance.exec(sql);
  }

  @override
  Future<List> query(String sql) async {
    return await dbInstance.query(sql);
  }
}
