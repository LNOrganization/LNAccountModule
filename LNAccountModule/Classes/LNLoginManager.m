//
//  LNLoginManager.m
//  LNLogin
//
//  Created by Lenny on 2020/6/30.
//

#import "LNLoginManager.h"
#import <LNModuleProtocol/LNLoginModuleProtocol.h>

@interface LNLoginManager ()<LNLoginModuleProtocol>

@end

@implementation LNLoginManager

+ (LNLoginManager *)sharedInstance
{
    static LNLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNLoginManager alloc] init];
    });
    return instance;
}


#pragma mark - LNAppLiftCycleDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"LNLoginManager 初始化");
    return YES;
}

- (void)doInitialize {
    
}

- (NSString *)version {
    return @"0.1.4";
}

- (BOOL)isLogin {
    return YES;
}

- (BOOL)login:(LNLoginCompletion)completion {
    return YES;
}

- (void)logout:(LNLoginCompletion)completion {
    
}

- (void)registerLoginCompletionNotify:(LNLoginCompletion)completion {
    
}

- (void)registerLogoutCompletionNotify:(LNLoginCompletion)completion {
    
}

- (BOOL)showLoginPageIfNeed {
    return YES;
}

@end
