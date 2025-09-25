// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'libsimple_flutter_platform_interface.dart';

/// A web implementation of the LibsimpleFlutterPlatform of the LibsimpleFlutter plugin.
class LibsimpleFlutterWeb extends LibsimpleFlutterPlatform {
  /// Constructs a LibsimpleFlutterWeb
  LibsimpleFlutterWeb();

  static void registerWith(Registrar registrar) {
    LibsimpleFlutterPlatform.instance = LibsimpleFlutterWeb();
    if (document.querySelector('#sqlite3script') == null) {
      //developing hot reload will do this multi times
      var sqlite3script = document.createElement('script');
      sqlite3script.textContent = script;
      sqlite3script.id = 'sqlite3script';
      document.querySelector("head")?.append(sqlite3script);
    }
  }

  static String script = '''
  let sqliteWorker;
  (function(){
      sqliteWorker = new Worker("assets/packages/libsimple_flutter/assets/sqlite/sqlite-worker.js");
    })();
  function callSqlite(method,args){
    return new Promise((resolve,reject)=>{
      sqliteWorker.postMessage([method,args]);
      sqliteWorker.onmessage = (e) => {
        resolve(e.data);
      }
    })
  }
''';

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = window.navigator.userAgent;
    return version;
  }
}
