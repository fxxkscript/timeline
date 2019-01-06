#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.tomo.wshop/share"
                                          binaryMessenger:controller];
  
  __weak typeof(self) weakSelf = self;
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"weixin" isEqualToString:call.method]) {
      [self share];
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)share {
  UIImage *imageToShare = [UIImage imageNamed:@"1.jpg"];
  UIImage *imageToShare1 = [UIImage imageNamed:@"1.jpg"];
  
  NSArray *activityItems = @[imageToShare,imageToShare1];
  
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
  
  [self.window.rootViewController presentViewController:activityVC animated:TRUE completion:nil];
}

@end
