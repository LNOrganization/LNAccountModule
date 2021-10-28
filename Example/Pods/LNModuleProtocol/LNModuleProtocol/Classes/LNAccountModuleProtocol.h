//
//  LNLoginModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import <Foundation/Foundation.h>
#import "LNModuleProtocol.h"


extern NSString * const LNAccountLoginSucceedNotification;
extern NSString * const LNAccountLogoutFinishNotification;

typedef void(^LNLoginCompletion)(NSDictionary *accountInfo, NSString * errMsg);
typedef void(^LNLogotCompletion)(void);

@protocol LNAccountModuleProtocol <LNModuleBaseProtocol>

- (BOOL)isLogin;

- (BOOL)loginIfNeed:(LNLoginCompletion)completion;

- (void)logout;

- (void)getAccountInfo:(LNLoginCompletion)completion;


- (void)registerLoginCompletionNotify:(LNLoginCompletion)completion
                               forKey:(NSString *)key;
- (void)removeLoginNotificationForKey:(NSString *)key;


- (void)registerLogoutCompletionNotify:(LNLogotCompletion)completion
                                forKey:(NSString *)key;
- (void)removeLogoutNotificationForKey:(NSString *)key;

@end
