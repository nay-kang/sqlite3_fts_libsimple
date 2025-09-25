import 'dart:js_interop';

/// Exception thrown when SQLite operations fail
class SqliteException implements Exception {
  final String message;
  SqliteException(this.message);

  @override
  String toString() => 'SqliteException: $message';
}

@JS()
external JSPromise<JSObject?> callSqlite(String method, JSArray args);

/// Tracks initialization state of SQLite
Future<void>? _initializationFuture;

/// Initializes the SQLite database.
///
/// [filename] is the name of the database file
/// [mode] specifies the database access mode
Future<void> init(String filename, String mode) {
  if (_initializationFuture != null) {
    throw SqliteException('SQLite is already initialized');
  }

  try {
    final promise = callSqlite('init', [filename.toJS, mode.toJS].toJS);
    _initializationFuture = promise.toDart.then((_) {});
    return _initializationFuture!;
  } catch (e) {
    throw SqliteException('Failed to initialize SQLite: $e');
  }
}

/// Executes a SQL query and returns the results.
///
/// [sql] is the SQL query to execute
/// [bind] is an optional list of parameters to bind to the query
Future<List<Map<String, dynamic>>> query(String sql,
    [List<dynamic> bind = const []]) async {
  if (_initializationFuture == null) {
    throw SqliteException('SQLite is not initialized. Call init() first.');
  }

  await _initializationFuture;

  try {
    final jsParams = listToJSArray(bind);
    final promise = callSqlite('exec', [sql.toJS, jsParams].toJS);
    final result = (await promise.toDart) as JSArray;

    return result.toDart
        .map((row) => (row.dartify() as Map).cast<String, dynamic>())
        .toList();
  } catch (e) {
    throw SqliteException('Query failed: $e');
  }
}

/// Executes a SQL statement without returning results.
///
/// [sql] is the SQL statement to execute
/// [bind] is an optional list of parameters to bind to the statement
Future<void> exec(String sql, [List<dynamic> bind = const []]) async {
  await query(sql, bind);
}

/// Converts a Dart List to a JavaScript Array.
/// fucking flutter; if using else if (item is num || item is bool || item is String) it will throw error NoSuchMethodError: 'toJS' method not found
/// Handles conversion of primitive types (String, num, bool) and
/// falls back to string representation for other types.
JSArray<JSAny> listToJSArray(List<dynamic> list) {
  final jsItems = <JSAny>[];
  for (final item in list) {
    if (item == null) {
      jsItems.add("".toJS);
      // } else if (item is num || item is bool || item is String) {
      //   jsItems.add(item.toJS);
    } else if (item is String) {
      jsItems.add(item.toJS);
    } else if (item is num) {
      jsItems.add(item.toJS);
    } else if (item is bool) {
      jsItems.add(item.toJS);
    } else {
      jsItems.add(item.toString().toJS);
    }
  }
  return jsItems.toJS;
}
