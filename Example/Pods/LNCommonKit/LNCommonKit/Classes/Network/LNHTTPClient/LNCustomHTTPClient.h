//
//  LNCustomHTTPClient.h
//  LNCommonKit
//
//  Created by Lenny on 2022/11/30.
//

#import <Foundation/Foundation.h>
#import "LNNetworkConst.h"

NS_ASSUME_NONNULL_BEGIN


@interface LNCustomHTTPClient : NSObject<LNHTTPClientDelegate>

+ (instancetype)client;

@end

NS_ASSUME_NONNULL_END
