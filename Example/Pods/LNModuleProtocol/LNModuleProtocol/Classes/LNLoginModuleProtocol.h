//
//  LNLoginModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import <Foundation/Foundation.h>
#import "LNModuleProtocol.h"

typedef void(^LNLoginCompletion)(NSDictionary *accountInfo, BOOL isSucceed);


@protocol LNLoginModuleProtocol <LNModuleBaseProtocol>

- (BOOL)isLogin;

- (BOOL)showLoginPageIfNeed;

- (BOOL)login:(LNLoginCompletion)completion;

- (void)logout:(LNLoginCompletion)completion;;

- (void)registerLoginCompletionNotify:(LNLoginCompletion)completion;

- (void)registerLogoutCompletionNotify:(LNLoginCompletion)completion;


@end
