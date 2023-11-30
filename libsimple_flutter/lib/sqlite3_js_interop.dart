import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('callSqlite')
external Object callSqlite(String method, List args);

Future? _inited;

void init(filename, mode) {
  var promise = callSqlite('init', [filename, mode]);
  _inited = promiseToFuture(promise);
}

Future<List?> query(String sql, [List bind = const []]) async {
  await _inited;

  /*
  const [] parameter will cause error 
  Error: DataCloneError: Failed to execute 'postMessage' on 'Worker': function Array() { [native code] } could not be cloned.
  so I had to change the bind to none-constant value
    */
  var params = List.from(bind);

  var promise = callSqlite('exec', [sql, params]);
  var result = await promiseToFuture(promise);
  var rtn = [];
  for (var row in result) {
    var d = dartify(row) as Map;
    rtn.add(d);
  }
  return rtn;
}

Future<void> exec(String sql, [List bind = const []]) async {
  await query(sql, bind);
}
