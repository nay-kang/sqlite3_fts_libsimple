// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'libsimple_flutter_platform_interface.dart';
import 'sqlite3_js_interop.dart' as sqlite3interop;

/// A web implementation of the LibsimpleFlutterPlatform of the LibsimpleFlutter plugin.
class LibsimpleFlutterWeb extends LibsimpleFlutterPlatform {
  /// Constructs a LibsimpleFlutterWeb
  LibsimpleFlutterWeb();

  static void registerWith(Registrar registrar) {
    LibsimpleFlutterPlatform.instance = LibsimpleFlutterWeb();
    sqlite3interop.injectSqliteInit();
    var sqlite3script = html.ScriptElement();
    sqlite3script.src =
        "https://cdn.jsdelivr.net/npm/sqlite3-libsimple-wasm@3.43.1/sqlite3.js";

    var bridgescript = html.ScriptElement();
    bridgescript.src =
        "assets/packages/libsimple_flutter/assets/sqlite3bridge.js";
    html.querySelector("head")?.children.add(sqlite3script);
    html.querySelector("head")?.children.add(bridgescript);
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
