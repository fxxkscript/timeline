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
  NSURL *imageURL = [NSURL URLWithString:@"https://ws3.sinaimg.cn/large/006tNc79gy1fyworuc0v0j3020020mx1.jpg"];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // Update the UI
      NSArray *activityItems = @[[UIImage imageWithData:imageData]];
      
      UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
      
      [self.window.rootViewController presentViewController:activityVC animated:TRUE completion:nil];
    });
  });

}

@end
