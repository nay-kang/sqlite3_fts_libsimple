
import 'libsimple_flutter_platform_interface.dart';

class LibsimpleFlutter {
  Future<String?> getPlatformVersion() {
    return LibsimpleFlutterPlatform.instance.getPlatformVersion();
  }
}
