//
//  LNFeedModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import <UIKit/UIKit.h>
#import "LNModuleProtocol.h"


@protocol LNFeedModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getRecommendFeedViewController;

- (UIViewController *)getTimeLineFeedViewController;

- (UIViewController *)getFeedDetailViewControllerWithFeedId:(NSString *)feedId;

@end
