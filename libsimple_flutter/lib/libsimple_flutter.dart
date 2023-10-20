import 'libsimple_flutter_platform_interface.dart';
import 'sqlite_native.dart' if (dart.library.html) 'sqlite_web.dart';

class LibsimpleFlutter {
  Future<String?> getPlatformVersion() {
    return LibsimpleFlutterPlatform.instance.getPlatformVersion();
  }

  Sqlite getSqlite(String filename) {
    return SqliteImpl(filename);
  }
}

abstract class Sqlite {
  String filename;
  Sqlite(this.filename);

  exec(String sql);
  Future<List> query(String sql);
}
