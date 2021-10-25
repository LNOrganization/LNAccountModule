//
//  LNAccountModuleConfig.h
//  LNAccountModule
//
//  Created by Lenny on 2021/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^LNAccountLoginCompletion)(NSDictionary * _Nullable accountInfo, NSError * _Nullable error);

@interface LNAccountModuleConfig : NSObject

@end

NS_ASSUME_NONNULL_END
