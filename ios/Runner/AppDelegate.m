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
      [weakSelf share:@[@"https://ws3.sinaimg.cn/large/006tNc79gy1fyworuc0v0j3020020mx1.jpg", @"https://ws3.sinaimg.cn/large/006tNc79gy1fywpblwgk4j3020020glf.jpg"]];
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
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
