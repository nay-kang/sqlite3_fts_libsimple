import 'package:flutter_test/flutter_test.dart';
import 'package:libsimple_flutter/libsimple_flutter.dart';
import 'package:libsimple_flutter/libsimple_flutter_platform_interface.dart';
import 'package:libsimple_flutter/libsimple_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLibsimpleFlutterPlatform
    with MockPlatformInterfaceMixin
    implements LibsimpleFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LibsimpleFlutterPlatform initialPlatform = LibsimpleFlutterPlatform.instance;

  test('$MethodChannelLibsimpleFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLibsimpleFlutter>());
  });

  test('getPlatformVersion', () async {
    LibsimpleFlutter libsimpleFlutterPlugin = LibsimpleFlutter();
    MockLibsimpleFlutterPlatform fakePlatform = MockLibsimpleFlutterPlatform();
    LibsimpleFlutterPlatform.instance = fakePlatform;

    expect(await libsimpleFlutterPlugin.getPlatformVersion(), '42');
  });
}
