#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "QiniuSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.doraemon.meizizi/door"
                                          binaryMessenger:controller];
  
  __weak typeof(self) weakSelf = self;
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"weixin" isEqualToString:call.method]) {
      [weakSelf share:call.arguments];
    } else if ([@"upload" isEqualToString:call.method]) {
      [weakSelf upload:call result:result];
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

- (void)share:(NSArray *)array
{
  NSLog(@"%@", array);
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (NSString *imageUrl in array) {
      NSLog(@"%@", imageUrl);
      NSString* webStringURL = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
      NSURL *url = [NSURL URLWithString:webStringURL];
      NSData *imageData = [NSData dataWithContentsOfURL:url];
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

- (void)upload:(FlutterMethodCall*)call result:(FlutterResult)result
{
  NSString *token = call.arguments[@"token"];
  FlutterStandardTypedData *imageData = call.arguments[@"imageData"];
  NSString *key = call.arguments[@"key"];
  
  QNUploadManager *upManager = [[QNUploadManager alloc] init];
  [upManager putData:[imageData data] key:key token:token
            complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
              NSLog(@"%@", info);
              NSLog(@"%@", resp);
              result(@(info.isOK));
            } option:[QNUploadOption defaultOptions]];


}

@end
