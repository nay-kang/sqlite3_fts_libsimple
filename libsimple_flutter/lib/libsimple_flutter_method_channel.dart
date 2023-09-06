import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'libsimple_flutter_platform_interface.dart';

/// An implementation of [LibsimpleFlutterPlatform] that uses method channels.
class MethodChannelLibsimpleFlutter extends LibsimpleFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('libsimple_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
