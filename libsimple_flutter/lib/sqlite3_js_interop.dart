import 'dart:async';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

// @anonymous
@JS()
class _Sqlite3 {
  // @JS('oo1')
  external _Sqlite3OO1 get oo1;
}

// @anonymous
@JS()
class _Sqlite3OO1 {
  // @JS('sqlit3.oo1.DB')
  @JS('DB')
  external _Sqlite3DB get DB;
}

// @anonymous
// @JS('sqlite3.oo1.DB')
@JS()
class _Sqlite3DB {
  // @JS('exec')
  external factory _Sqlite3DB(String filename, String? mode, dynamic? vfs);
  // external void exec(String? sql, ExecOptions options);
  external void exec(ExecOptions options);
}

@JS()
@anonymous
class ExecOptions {
  external factory ExecOptions({sql, rowMode, callback, resultRows});
  external String get sql;
  external String get rowwMode;
  // external void Function(dynamic) get callback;
  external dynamic get callback;
  external List get resultRows;
}

// @JS('onQueryResult')
// external set _onQueryResult(void Function(dynamic) f);

@JS('sqliteInited')
external set _sqliteInited(void Function(_Sqlite3) f);

var instanceFuture = Completer<_Sqlite3>();

void _dartSqliteInited(_Sqlite3 sqlite3) async {
  instanceFuture.complete(sqlite3);
  return;
}

class SqliteDart {
  String filename;
  SqliteDart(this.filename);

  _Sqlite3DB? db;
  Future<dynamic> getDb() async {
    if (db != null) {
      return db;
    }
    var instance = await instanceFuture.future;
    var oo = instance.oo1;
    var sqliteDB = oo.DB;
    db = callConstructor(sqliteDB, [filename, 'ct']) as _Sqlite3DB;
    return db;
  }

  exec(String sql) async {
    var db = await getDb();
    db.exec(ExecOptions(sql: sql));
  }

  query(String sql) async {
    var db = await getDb();
    var result = [];
    db.exec(ExecOptions(sql: sql, rowMode: 'object', resultRows: result));
    var rtn = [];
    for (var row in result) {
      var d = dartify(row) as Map;
      rtn.add(d);
    }
    return rtn;
  }
}

Future<void> injectSqliteInit() async {
  _sqliteInited = allowInterop(_dartSqliteInited);
}
