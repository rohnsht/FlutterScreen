#import "ScreenPlugin.h"
#if __has_include(<screen/screen-Swift.h>)
#import <screen/screen-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "screen-Swift.h"
#endif

@implementation ScreenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScreenPlugin registerWithRegistrar:registrar];
}
@end
