//
//  LNNetworkConfig.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/2.
//

#import <Foundation/Foundation.h>
#import "LNNetworkConst.h"


@interface LNNetworkConfig : NSObject<LNNetworkConfigAdapter>

+ (instancetype)sharedInstance;


@end

