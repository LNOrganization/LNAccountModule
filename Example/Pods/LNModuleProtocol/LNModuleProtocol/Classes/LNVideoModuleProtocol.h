//
//  LNVideoModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import <Foundation/Foundation.h>
#import "LNProtocolConifg.h"

@protocol LNVideoModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getRecommendVideoViewController;

- (UIViewController *)getTimeLineVideoViewController;

@end
