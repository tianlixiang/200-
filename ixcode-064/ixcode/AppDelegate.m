#import "AppDelegate.h"
#import "ViewController.h"


#import "i063ViewController.h"
#import "i064ViewController.h"
#import "i065ViewController.h"

#import <AdSupport/ASIdentifierManager.h>

APIConnection *globalConn;

@interface AppDelegate ()


@end

@implementation AppDelegate
static NSString *appKey = @"ba310e9d793317bcc99992d6";
static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[i064ViewController alloc] init]];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    // singleton, init once, used through out app
    globalConn = [[APIConnection alloc] init];
    
    [globalConn.client_info setObject:@"ios" forKey:@"clienttype"];
    
    // no need to listen for state changed event yet
    [globalConn setWsURL:@"ws://112.124.70.60:51727/demo"];
    [globalConn connect];
    
    [self JPushAction:launchOptions];

    return YES;
}


- (void)JPushAction:(NSDictionary *)launchOptions{
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |              UIRemoteNotificationTypeAlert) categories:nil];
    }
    
   
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
}

#pragma -mark 注册deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册   DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    
    if (application.applicationState == UIApplicationStateActive) {
         NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息" message:alert delegate:self
         cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
 
  
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#pragma mark 推送失败后调取方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


@end
