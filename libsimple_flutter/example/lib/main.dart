import 'package:flutter/material.dart';
import 'dart:async';
import 'package:libsimple_flutter/libsimple_flutter.dart';
import 'package:synchronized/synchronized.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String content = 'Unknown';
  final libsimpleFlutterPlugin = LibsimpleFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String debugOutput = '';

    var sqlite = libsimpleFlutterPlugin.getSqlite('mydb.sqlite3');
    var version = await sqlite.query("select sqlite_version();");
    debugOutput += "$version\n";
    debugPrint(version.toString());
    await sqlite.exec(
        "CREATE VIRTUAL TABLE if not exists t1 USING fts5(x,y, tokenize = 'simple')");
    await sqlite.exec("delete from t1;");
    await sqlite.exec(
        '''insert into t1(x,y) values ('周杰伦 Jay Chou:最美的不是下雨天，是曾与你躲过雨的屋檐',1),
                         ('I love China! 我爱中国!',2),
                         ('周杰伦演唱会',3),
                         ('@English &special _characters."''bacon-&and''-eggs%',4);''');

    var d = await sqlite
        .query("select * from t1 where x match simple_query(?)", ['jielun']);
    debugOutput += d.toString();

    for (var i = 0; i < 5; i++) {
      multipleSql(sqlite, 'x$i', 'y$i');
    }

    debugPrint(d.toString());

    if (!mounted) return;

    setState(() {
      content = debugOutput;
    });
  }

  /// Use a lock to ensure that multiple SQL statements are executed sequentially.
  var dbLock = Lock();
  Future<void> multipleSql(Sqlite sqlite, String x, String y) async {
    await dbLock.synchronized(() async {
      await sqlite.exec("insert into t1(x,y) values (?,?);", [x, y]);
      await sqlite.exec("delete from t1 where y=?;", [y]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Sqlite Test: $content\n'),
        ),
      ),
    );
  }
}
