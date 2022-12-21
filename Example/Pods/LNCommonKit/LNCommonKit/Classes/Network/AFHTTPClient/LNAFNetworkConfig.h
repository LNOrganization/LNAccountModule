//
//  LNAFNetworkConfig.h.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/2.
//

#import <Foundation/Foundation.h>


@protocol LNNetworkConfigAdapter;

@interface LNAFNetworkConfig : NSObject<LNNetworkConfigAdapter>

+ (instancetype)sharedInstance;


@end

