//
//  LNFeedModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import "LNProtocolConifg.h"


@protocol LNFeedModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getMainFeedViewController;

- (UIViewController *)getRecommendFeedViewController;

- (UIViewController *)getTimeLineFeedViewController;

- (UIViewController *)getFeedDetailViewControllerWithFeedId:(NSString *)feedId;

@end
