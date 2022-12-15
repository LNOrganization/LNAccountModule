//
//  LNLoginModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import "LNProtocolConfig.h"


extern NSString * const LNAccountLoginNotification;
extern NSString * const LNAccountLogoutNotification;

typedef void(^LNLoginBlock)(NSDictionary *userInfo, NSError * error);
typedef void(^LNLogoutBlock)(void);

@protocol LNAccountModuleProtocol <LNModuleBaseProtocol>

- (BOOL)isLogin;

- (BOOL)loginIfNeed:(LNLoginBlock)completion;

- (void)logout;

- (NSDictionary *)getLoginUserInfo;

- (void)addObserver:(id)observer forLoginBlock:(LNLoginBlock)block;
- (void)addObserver:(id)observer forLogoutBlock:(LNLogoutBlock)block;

@end
