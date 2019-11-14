#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "FlutterDownloaderPlugin.h"

@implementation AppDelegate

void registerPlugins(NSObject<FlutterPluginRegistry>* registry) {
  //
  // Integration note:
  //
  // In Flutter, in order to work in background isolate, plugins need to register with
  // a special instance of `FlutterEngine` that serves for background execution only.
  // Hence, all (and only) plugins that require background execution feature need to
  // call `registerWithRegistrar` in this function.
  //
  // The default `GeneratedPluginRegistrant` will call `registerWithRegistrar` of all
  // plugins integrated in your application. Hence, if you are using `FlutterDownloaderPlugin`
  // along with other plugins that need UI manipulation, you should register
  // `FlutterDownloaderPlugin` and any 'background' plugins explicitly like this:
  //
  // [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"vn.hunghd.flutter_downloader"]];
  //
  [GeneratedPluginRegistrant registerWithRegistry:registry];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.meizizi.doraemon/door"
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
  [FlutterDownloaderPlugin setPluginRegistrantCallback:registerPlugins];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

- (void)share:(NSDictionary *)dict
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (NSString *imageUrl in [dict objectForKey:@"pics"]) {
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

@end
