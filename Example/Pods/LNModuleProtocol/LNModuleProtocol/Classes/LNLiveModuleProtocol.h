//
//  LNLiveModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import <UIKit/UIKit.h>
#import "LNModuleBaseProtocol.h"

@protocol LNLiveModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getLiveFocusListViewController;

- (UIViewController *)getLiveTimeLineListViewController;

- (UIViewController *)getLiveRoomViewController;

- (UIViewController *)getLiveAnchorViewController;

@end

