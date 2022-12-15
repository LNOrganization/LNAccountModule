//
//  LNLoginManager.m
//  LNLogin
//
//  Created by Lenny on 2020/6/30.
//

#import "LNLoginManager.h"
#import <LNCommonKit/LNCommonKit.h>
#import <LNModuleProtocol/LNAccountModuleProtocol.h>
#import <LNModuleCore/LNModuleCore.h>

#import "LNLoginViewController.h"
#import "LNAccountModuleConfig.h"

#define kLNLoginAccount @"LNModuleCacheState"


__attribute__((constructor)) void addModuleAccountModule(void){
    [[LNModuleManager sharedInstance] addImpClassName:@"LNLoginManager" protocolName:@"LNAccountModuleProtocol"];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        [[LNModuleManager sharedInstance] addImpClassName:@"LNLoginManager" protocolName:@"LNAccountModuleProtocol"];
//    });
}


//@interface LNObserverLink : NSObject
//
//@property(nonatomic, weak) id block;
//@property(nonatomic, weak) id observer;
//
//@property(nonatomic, strong) LNObserverLink *next;
//
//@end
//
//@implementation LNObserverLink
//
//@end


@interface LNLoginManager ()<LNAccountModuleProtocol>

/** 登录通知回调，key:observer, value:LNLoginBlock */
@property(nonatomic, strong) LNMapTable *loginNotifications;

/** 登出通知回调，key:observer, value:LNLogoutBlock */
@property(nonatomic, strong) LNMapTable *logoutNotifications;

//@property(nonatomic, strong) LNObserverLink *loginLink;
//@property(nonatomic, strong) LNObserverLink *logoutLink;

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
        
        // NSPointerFunctionsWeakMemory weak引用observer，不持有，对象销毁时自动注销LNLoginBlock
        _loginNotifications = [[LNMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                        valueOptions:NSPointerFunctionsCopyIn
                                                            capacity:0];
        // NSPointerFunctionsWeakMemory weak引用observer，不持有，对象销毁时自动注销LNLogoutBlock
        _logoutNotifications = [[LNMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                         valueOptions:NSPointerFunctionsCopyIn
                                                             capacity:0];;
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

- (void)getAccountInfo:(LNLoginBlock)completion {
    
}


- (BOOL)loginIfNeed:(LNLoginBlock)completion {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:LNAccountLogoutNotification object:nil];
    [[self.logoutNotifications objectEnumerator].allObjects enumerateObjectsUsingBlock:^(LNLogoutBlock  _Nonnull block, NSUInteger idx, BOOL * _Nonnull stop) {
        block();
    }];
//    [[self.logoutNotifications copy] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LNLogoutCompletion  _Nonnull obj, BOOL * _Nonnull stop) {
//        obj();
//    }];
    
}

- (void)addObserver:(id)observer forLoginBlock:(LNLoginBlock)block
{
    [self.loginNotifications setObject:block forKey:observer];
}

- (void)addObserver:(id)observer forLogoutBlock:(LNLogoutBlock)block
{
    [self.logoutNotifications setObject:block forKey:observer];
}

- (NSDictionary *)getLoginUserInfo {
    return nil;
}



- (void)showLoginViewControllerWithCompletion:(LNLoginBlock)completion
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
            [[NSNotificationCenter defaultCenter] postNotificationName:LNAccountLoginNotification object:nil userInfo:accountInfo];
        }
        [strongLoginVc dismissViewControllerAnimated:YES completion:^{
            if (completion) {
                completion(accountInfo, error);
            }
            [[weakSelf.loginNotifications objectEnumerator].allObjects enumerateObjectsUsingBlock:^(LNLoginBlock  _Nonnull block, NSUInteger idx, BOOL * _Nonnull stop) {
                block(accountInfo, error);
            }];
        }];
    };
    [[LNRouter currentViewController] presentViewController:loginVc animated:YES completion:nil];
}

@end
