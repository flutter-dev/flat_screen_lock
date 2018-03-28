#import "FlatScreenLockPlugin.h"
#import <flat_screen_lock/flat_screen_lock-Swift.h>

@implementation FlatScreenLockPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlatScreenLockPlugin registerWithRegistrar:registrar];
}
@end
