//
//  LNLiveModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//


#import "LNProtocolConfig.h"

@protocol LNLiveModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getRecommendListViewController;

- (UIViewController *)getFocusListViewController;

- (UIViewController *)getTimeLineListViewController;

- (UIViewController *)getLiveRoomViewControllerWithRoomId:(NSString *)roomId;

- (UIViewController *)getLiveAnchorViewControllerWithUserId:(NSString *)userId;

@end

