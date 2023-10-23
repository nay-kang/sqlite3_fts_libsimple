import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:libsimple_flutter/libsimple_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _libsimpleFlutterPlugin = LibsimpleFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _libsimpleFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    var sqlite = _libsimpleFlutterPlugin.getSqlite('mydb.sqlite3');
    await sqlite.exec(
        "CREATE VIRTUAL TABLE if not exists t1 USING fts5(x,y, tokenize = 'simple')");
    await sqlite.exec("delete from t1;");
    await sqlite.exec(
        '''insert into t1(x,y) values ('周杰伦 Jay Chou:最美的不是下雨天，是曾与你躲过雨的屋檐',1),
                         ('I love China! 我爱中国!',2),
                         ('周杰伦演唱会',3),
                         ('@English &special _characters."''bacon-&and''-eggs%',4);''');

    var d = await sqlite
        .query("select * from t1 where x match simple_query('zhoujiel')");
    print(d);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
