import 'dart:async';

import 'package:sqlite3/sqlite3.dart';
import 'libsimple_flutter.dart' show Sqlite;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SqliteImpl extends Sqlite {
  Completer dbCompleter = Completer<Database>();
  SqliteImpl(super.filename) {
    getApplicationDocumentsDirectory().then((folder) {
      var p = path.join(folder.path, filename);
      var dbInstance = sqlite3.open(p);
      dbCompleter.complete(dbInstance);
    });
  }

  @override
  exec(String sql, [List bind = const []]) async {
    var dbInstance = await dbCompleter.future;
    dbInstance.execute(sql, bind);
  }

  @override
  Future<List> query(String sql, [List bind = const []]) async {
    var dbInstance = await dbCompleter.future;
    var re = dbInstance.select(sql, bind);
    List rtn = [];
    for (var row in re) {
      rtn.add(row);
    }
    return rtn;
  }
}
