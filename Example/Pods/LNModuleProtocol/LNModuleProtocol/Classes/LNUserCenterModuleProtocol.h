//
//  LNUserCenterModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2022/12/9.
//

#import "LNProtocolConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LNUserInfoBlock)(NSDictionary *userInfo);
@protocol LNUserCenterModuleProtocol <LNModuleBaseProtocol>

- (void)getUserInfoWithCompletion:(LNUserInfoBlock)block;

- (UIViewController *)getMineViewController;

- (UIViewController *)getUserCenterViewControllerWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
