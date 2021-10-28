//
//  LNModuleAppDelegate.m
//  LNCore
//
//  Created by Lenny on 2021/10/12.
//  Copyright © 2021 dongjianxiong. All rights reserved.
//

#import "LNModuleAppDelegate.h"
#import "LNModuleManager.h"

@interface LNModuleAppDelegate()

@property(nonatomic, strong) LNModuleManager *manager;

@end


@implementation LNModuleAppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions
{
    self.manager = [LNModuleManager sharedInstance];
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [modul application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }];
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationDidFinishLaunching:)]) {
            [modul applicationDidFinishLaunching:application];
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [modul applicationDidBecomeActive:application];
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationWillResignActive:)]) {
            [modul applicationWillResignActive:application];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationWillTerminate:)]) {
            [modul applicationWillTerminate:application];
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [modul applicationDidEnterBackground:application];
        }
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [modul applicationWillEnterForeground:application];
        }
    }];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
            if (@available(iOS 9.0, *)) {
               [modul application:application openURL:url options:options];
            } else {
                // Fallback on earlier versions
            }
        }
    }];

    return YES;
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    NSDictionary *moduls = [self.manager allImpInstanceInfos];
//    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
//        if ([modul respondsToSelector:@selector(application:handleOpenURL:)]) {
//            [modul application:application handleOpenURL:url];
//        }
//    }];
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(nullable NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    NSDictionary *moduls = [self.manager allImpInstanceInfos];
//    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
//        if ([modul respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
//            [modul application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//        }
//    }];
//    return YES;
//}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
{
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [modul applicationDidReceiveMemoryWarning:application];
        }
    }];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationSignificantTimeChange:)]) {
            [modul applicationSignificantTimeChange:application];
        }
    }];
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:willChangeStatusBarOrientation:duration:)]) {
            [modul application:application willChangeStatusBarOrientation:newStatusBarOrientation duration:duration];
        }
    }];
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didChangeStatusBarOrientation:)]) {
            [modul application:application didChangeStatusBarOrientation:oldStatusBarOrientation];
        }
    }];
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:willChangeStatusBarFrame:)]) {
            [modul application:application willChangeStatusBarFrame:newStatusBarFrame];
        }
    }];
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didChangeStatusBarFrame:)]) {
            [modul application:application didChangeStatusBarFrame:oldStatusBarFrame];
        }
    }];
}

 - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
     
     NSDictionary *moduls = [self.manager allImpInstanceInfos];
     [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
         id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
         if ([modul respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
             [modul application:application didRegisterUserNotificationSettings:notificationSettings];
         }
     }];
 }

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [modul application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [modul application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            [modul application:application didReceiveRemoteNotification:userInfo];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
            [modul application:application didReceiveLocalNotification:notification];
        }
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:)]) {
            [modul application:application handleActionWithIdentifier:identifier forLocalNotification:notification  completionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:)]) {
            if (@available(iOS 9.0, *)) {
                [modul application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)]) {
            [modul application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:)]) {
            if (@available(iOS 9.0, *)) {
                [modul application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [modul application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:performFetchWithCompletionHandler:)]) {
            [modul application:application performFetchWithCompletionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler  API_AVAILABLE(ios(9.0)){
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:performActionForShortcutItem:completionHandler:)]) {
            if (@available(iOS 9.0, *)) {
                [modul application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}

- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleEventsForBackgroundURLSession:completionHandler:)]) {
            [modul application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleWatchKitExtensionRequest:reply:)]) {
            if (@available(iOS 8.2, *)) {
                [modul application:application handleWatchKitExtensionRequest:userInfo reply:reply];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}

- (void)applicationShouldRequestHealthAuthorization:(UIApplication *)application {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationShouldRequestHealthAuthorization:)]) {
            if (@available(iOS 9.0, *)) {
                [modul applicationShouldRequestHealthAuthorization:application];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}

- (nullable id)application:(UIApplication *)application handlerForIntent:(INIntent *)intent{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    id obj = nil;
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handlerForIntent:)]) {
            if (@available(iOS 14.0, *)) {
                obj = [modul application:application handlerForIntent:intent];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
    return obj;
}

- (void)application:(UIApplication *)application
       handleIntent:(INIntent *)intent
  completionHandler:(void(^)(INIntentResponse *intentResponse))completionHandler {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(application:handleIntent:completionHandler:)]) {
            if (@available(iOS 11.0, *)) {
                [modul application:application handleIntent:intent completionHandler:completionHandler];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationProtectedDataWillBecomeUnavailable:)]) {
            [modul applicationProtectedDataWillBecomeUnavailable:application];
        }
    }];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application{
    
    NSDictionary *moduls = [self.manager allImpInstanceInfos];
    [moduls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id<UIApplicationDelegate> modul = (id<UIApplicationDelegate>)obj;
        if ([modul respondsToSelector:@selector(applicationProtectedDataDidBecomeAvailable:)]) {
            [modul applicationProtectedDataDidBecomeAvailable:application];
        }
    }];
}

@end
