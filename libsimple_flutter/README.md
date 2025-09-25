# libsimple_flutter

A full-text search engine based on sqlite.

## Getting Started

```dart
final libsimpleFlutterPlugin = LibsimpleFlutter();
final sqlite = libsimpleFlutterPlugin.getSqlite('test.db');
await sqlite.exec("CREATE VIRTUAL TABLE if not exists t1 USING fts5(x,y, tokenize = 'simple')");
const rows = await sqlite.query("select * from t1 where x match simple_query(?)", ['keyword']);
for(var row in rows){
    print(row['x'])
}
```

more details can view in example/lib/main.dart