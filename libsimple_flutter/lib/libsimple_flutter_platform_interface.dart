import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'libsimple_flutter_method_channel.dart';

abstract class LibsimpleFlutterPlatform extends PlatformInterface {
  /// Constructs a LibsimpleFlutterPlatform.
  LibsimpleFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static LibsimpleFlutterPlatform _instance = MethodChannelLibsimpleFlutter();

  /// The default instance of [LibsimpleFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelLibsimpleFlutter].
  static LibsimpleFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LibsimpleFlutterPlatform] when
  /// they register themselves.
  static set instance(LibsimpleFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
