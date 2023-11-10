import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('callSqlite')
external Object callSqlite(String method, List args);

Future? _inited;

void init(filename, mode) {
  var promise = callSqlite('init', [filename, mode]);
  _inited = promiseToFuture(promise);
}

Future<List?> query(String sql, [List? bind]) async {
  await _inited;
  var promise = callSqlite('exec', [sql, bind]);
  var result = await promiseToFuture(promise);
  var rtn = [];
  for (var row in result) {
    var d = dartify(row) as Map;
    rtn.add(d);
  }
  return rtn;
}

Future<void> exec(String sql, [List? bind]) async {
  await query(sql, bind);
}
