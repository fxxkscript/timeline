#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "WXApi.h"
#import "FluwxResponseHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.meizizi.doraemon/share"
                                          binaryMessenger:controller];
  
  __weak typeof(self) weakSelf = self;
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"weixin" isEqualToString:call.method]) {
      [weakSelf share:call.arguments];
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

- (void)share:(NSArray *)array{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (NSString *imageUrl in array) {
      NSURL *imageURL = [NSURL URLWithString:imageUrl];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      [imageList addObject:imageData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // Update the UI
      NSMutableArray *images = [[NSMutableArray alloc] init];
      for (NSData *data in imageList) {
        [images addObject:[UIImage imageWithData:data]];
      }
      
      NSArray *activityItems = images;
      
      UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
      
      [self.window.rootViewController presentViewController:activityVC animated:TRUE completion:nil];
    });
  });

}

@end
