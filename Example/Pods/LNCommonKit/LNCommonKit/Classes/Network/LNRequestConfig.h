//
//  LNRequestConfig.h
//  LNFeedModule
//
//  Created by Lenny on 2022/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 请求通用配置*/
@protocol LNRequestConfigAdapter <NSObject>

@required
/** 请求基础 API */
@property (nonatomic, copy, nullable) NSString *baseURL;
/** 通用参数 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *commonParameters;
/** 通用请求头 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *commonHeaders;
/** 用户信息 */
@property (nonatomic, strong, nullable) NSDictionary *commonUserInfo;
@end


@interface LNRequestConfig : NSObject<LNRequestConfigAdapter>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
