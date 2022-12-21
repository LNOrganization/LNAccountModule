//
//  LNNetworkConst.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * _Nonnull LNRequestSerializationErrorDomain;
FOUNDATION_EXPORT NSString * _Nonnull LNResponseSerializationErrorDomain;


typedef NS_ENUM(NSInteger, LNRequestType) {
    LNRequestNormal    = 0,
    LNRequestUpload    = 1
};

typedef NS_ENUM(NSInteger, LNRequestSerializerType) {
    LNRequestSerializerHTTP     = 0,
    LNRequestSerializerJSON    = 1,
};

typedef NS_ENUM(NSInteger, LNResponseSerializerType) {
    LNResponseSerializerHTTP       = 0,
    LNResponseSerializerJSON       = 1,
    LNResponseSerializerXMLParser  = 2
};

typedef NS_ENUM(NSUInteger, LNHTTPMethodType) {
    LNHTTPMethodTypeGet = 0,
    LNHTTPMethodTypePost,
    LNHTTPMethodTypePut,
    LNHTTPMethodTypeDelete,
    LNHTTPMethodTypeHead,
    LNHTTPMethodTypePatch,
};

typedef NS_ENUM(NSUInteger, LNRequestLocalErrorCode) {
    LNRequestLocalErrorInvalidParams = 3000,//参数错误
    LNRequestLocalErrorInvalidResponseData  = 3001,// 相应无效
    LNRequestLocalErrorInvalidRequestMethod = 3002,// 无效请求方法
    LNRequestLocalErrorInvalidRequestType = 3003, //请求类型无效
    LNRequestLocalErrorInvalidRequestSerializer = 3004, // 无效请求序列化
    LNRequestLocalErrorInvalidResponseSerializer = 3005, // 无效相应序列化
    LNRequestLocalErrorInvalidNetwork = 3006, // 网络连接失败
};


extern NSString * _Nullable LNHTTPMethodWithType(LNHTTPMethodType type);
extern NSString * _Nonnull LNURLPathWithBaseURLAppendPath(NSString * _Nonnull host, NSString * _Nonnull path);

@class LNHTTPRequest;
typedef void(^LNRequestCompletionBlock)(id _Nullable data, NSError * _Nullable error);
typedef void(^LNRequestProgressBlock)(NSProgress * _Nonnull progress);

typedef void (^LNRequestCreator)(LNHTTPRequest * request);
typedef void (^LNRequestSuccessBlock)(id data);
typedef void (^LNRequestFailureBlock)(NSError *error);
typedef void (^LNRequestProgressBlock)(NSProgress *progress);
typedef void(^ParametersCreator)(NSMutableDictionary *params);

@protocol LNHTTPClientDelegate <NSObject>
@optional
/** 子类根据需要可以重写自定义 NSURLSessionDataTask*/
- (NSURLSessionDataTask *_Nullable)dataTaskWithRequest:(nonnull LNHTTPRequest *)request
                                     progress:(LNRequestProgressBlock _Nullable )progress
                                   completion:(nonnull LNRequestCompletionBlock)completion;
                    
@end


/** 请求通用配置*/
@protocol LNNetworkConfigAdapter <NSObject>

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



@interface LNNetworkConst : NSObject

@end

NS_ASSUME_NONNULL_END
