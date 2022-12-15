//
//  LNLoginManager.m
//  LNLogin
//
//  Created by Lenny on 2020/6/30.
//

#import "LNLoginManager.h"
#import <LNModuleCore/LNModuleCore.h>
#import <LNCommonKit/LNCommonKit.h>
#import <LNModuleProtocol/LNAccountModuleProtocol.h>
#import "LNLoginViewController.h"
#import "LNAccountModuleConfig.h"

#define kLNLoginAccount @"LNModuleCacheState"

NSString * const LNAccountLoginSucceedNotification = @"kLNAccountLoginSucceedNotification";
NSString * const LNAccountLogoutFinishNotification = @"kLNAccountLogoutFinishNotification";


__attribute__((constructor)) void addModulAccountModule(void){
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[LNModuleManager sharedInstance] addImpClassName:@"LNLoginManager" protocolName:@"LNAccountModuleProtocol"];
    });
}

@interface LNLoginManager ()<LNAccountModuleProtocol>

@property(nonatomic, strong) LNSafeMutableDictionary *loginNotifications;

@property(nonatomic, strong) LNSafeMutableDictionary *logoutNotifications;

@property(nonatomic, strong) LNHashTable *weakHashTable;

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


- (instancetype)init
{
    self = [super init];
    if (self) {
        _loginNotifications = [[LNSafeMutableDictionary alloc] init];
        _logoutNotifications = [[LNSafeMutableDictionary alloc] init];
        _weakHashTable = [[LNHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return self;
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

#pragma mark - LNAccountModuleProtocol
- (BOOL)isLogin {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:kLNLoginAccount] != nil;
}

- (void)getAccountInfo:(LNLoginCompletion)completion {
    
}


- (BOOL)loginIfNeed:(LNLoginCompletion)completion {
    if ([self isLogin]) {
        return YES;
    }else{
        [self showLoginViewControllerWithCompletion:completion];
    }
    return NO;
}


- (void)logout {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kLNLoginAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LNAccountLogoutFinishNotification object:nil];
    [[self.logoutNotifications copy] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LNLogoutCompletion  _Nonnull obj, BOOL * _Nonnull stop) {
        obj();
    }];
}

- (void)registerLoginCompletionNotify:(LNLoginCompletion)completion forKey:(NSString *)key {
    if (key && completion && ![self.loginNotifications objectForKey:key]) {
        [self.loginNotifications setObject:completion forKey:key];
    }
}

- (void)removeLoginNotificationForKey:(NSString *)key
{
    if (key && [self.loginNotifications objectForKey:key]) {
        [self.loginNotifications removeObjectForKey:key];
    }
}

- (void)registerLogoutCompletionNotify:(LNLogoutCompletion)completion forKey:(NSString *)key {
    if (key && completion && ![self.loginNotifications objectForKey:key]) {
        [self.logoutNotifications setObject:completion forKey:key];
    }
}


- (void)removeLogoutNotificationForKey:(NSString *)key
{
    if (key && [self.loginNotifications objectForKey:key]) {
        [self.logoutNotifications removeObjectForKey:key];
    }
}

- (void)showLoginViewControllerWithCompletion:(LNLoginCompletion)completion
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *realBundlePath = [NSString stringWithFormat:@"%@/%@",bundle.bundlePath,@"LNAccountModule.bundle"];
    NSBundle *realBundle = [NSBundle bundleWithPath:realBundlePath];
    
    LNLoginViewController *loginVc = [[LNLoginViewController alloc] initWithNibName:@"LNLoginViewController" bundle:realBundle];
    loginVc.modalPresentationStyle = 0;
    __weak typeof(LNLoginViewController) *weakLoginVc = loginVc;
    __weak typeof(self) weakSelf = self;
    loginVc.loginCompletion = ^(NSDictionary * _Nullable accountInfo, NSError * _Nullable error) {
        __strong typeof(LNLoginViewController) *strongLoginVc = weakLoginVc;
        if (!error && accountInfo) {
            [[NSUserDefaults standardUserDefaults] setValue:accountInfo forKey:kLNLoginAccount];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:LNAccountLoginSucceedNotification object:nil userInfo:accountInfo];
        }
        [strongLoginVc dismissViewControllerAnimated:YES completion:^{
            if (completion) {
                completion(accountInfo, error.description);
            }
            [[weakSelf.loginNotifications copy] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LNLoginCompletion  _Nonnull obj, BOOL * _Nonnull stop) {
                obj(accountInfo, error.description);
            }];
        }];
    };
    [[LNRouter currentViewController] presentViewController:loginVc animated:YES completion:nil];
}

@end
