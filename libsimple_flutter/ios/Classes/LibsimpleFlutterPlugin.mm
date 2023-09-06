#import "LibsimpleFlutterPlugin.h"
#import <sqlite3.h>

#ifdef __cplusplus
extern "C" {
#endif

void sqlite3_simple_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi);

#ifdef __cplusplus
}
#endif

@implementation LibsimpleFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
          methodChannelWithName:@"libsimple_flutter"
                binaryMessenger:[registrar messenger]];
    LibsimpleFlutterPlugin* instance = [[LibsimpleFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    sqlite3_auto_extension((void (*)(void)) sqlite3_simple_init);
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
