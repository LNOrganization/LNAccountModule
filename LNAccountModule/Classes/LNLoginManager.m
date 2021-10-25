//
//  LNLoginManager.m
//  LNLogin
//
//  Created by Lenny on 2020/6/30.
//

#import "LNLoginManager.h"
#import <LNModuleCore/LNModuleCore.h>
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

@property(nonatomic, strong) NSMutableDictionary *loginNotifications;

@property(nonatomic, strong) NSMutableDictionary *logoutNotifications;

@property(nonatomic, strong) NSRecursiveLock *loginLock;
@property(nonatomic, strong) NSRecursiveLock *logoutLock;

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
        _loginNotifications = [[NSMutableDictionary alloc] init];
        _logoutNotifications = [[NSMutableDictionary alloc] init];
        _loginLock = [[NSRecursiveLock alloc] init];
        _logoutLock = [[NSRecursiveLock alloc] init];
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
    [_logoutLock lock];
    [self.logoutNotifications enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LNLogotCompletion  _Nonnull obj, BOOL * _Nonnull stop) {
        obj();
    }];
    [_logoutLock unlock];
}

- (void)registerLoginCompletionNotify:(LNLoginCompletion)completion forKey:(NSString *)key {
    if (key && completion && ![self.loginNotifications objectForKey:key]) {
        [_loginLock lock];
        [self.loginNotifications setObject:completion forKey:key];
        [_loginLock unlock];
    }
}

- (void)removeLoginNotificationForKey:(NSString *)key
{
    if (key && [self.loginNotifications objectForKey:key]) {
        [_loginLock lock];
        [self.loginNotifications removeObjectForKey:key];
        [_loginLock unlock];
    }
}

- (void)registerLogoutCompletionNotify:(LNLogotCompletion)completion forKey:(NSString *)key {
    if (key && completion && ![self.loginNotifications objectForKey:key]) {
        [_logoutLock lock];
        [self.logoutNotifications setObject:completion forKey:key];
        [_logoutLock unlock];
    }
}


- (void)removeLogoutNotificationForKey:(NSString *)key
{
    if (key && [self.loginNotifications objectForKey:key]) {
        [_logoutLock lock];
        [self.logoutNotifications removeObjectForKey:key];
        [_logoutLock unlock];
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
            [weakSelf.loginLock lock];
            [weakSelf.loginNotifications enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LNLoginCompletion  _Nonnull obj, BOOL * _Nonnull stop) {
                obj(accountInfo, error.description);
            }];
            [weakSelf.loginLock unlock];
        }];
    };
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:nil];
}

@end
