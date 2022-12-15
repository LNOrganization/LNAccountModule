//
//  LNAppDelegate.m
//  LNAccountModule
//
//  Created by dongjianxiong on 10/22/2021.
//  Copyright (c) 2021 dongjianxiong. All rights reserved.
//

#import "LNAppDelegate.h"
#import <LNModuleCore/LNModuleCore.h>
#import <LNModuleProtocol/LNAccountModuleProtocol.h>
#import "LNViewController.h"
#import "LNTestManager.h"
@implementation LNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    LNViewController *vc = [[LNViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    
    id <LNAccountModuleProtocol> accountModule = [[LNModuleManager sharedInstance] impInstanceForProtocol:@protocol(LNAccountModuleProtocol)];
    [accountModule addObserver:self forLoginBlock:^(NSDictionary *userInfo, NSError *errMsg) {
        NSLog(@"login");
    }];
    
    [accountModule logout];
    
    [accountModule addObserver:self forLogoutBlock:^{
        NSLog(@"logout");
    }];
    

    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        NSLog(@"1");
    } observer:self];
    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        NSLog(@"2");
    } observer:self];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
