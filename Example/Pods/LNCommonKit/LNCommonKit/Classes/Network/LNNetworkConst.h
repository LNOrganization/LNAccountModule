//
//  LNNetworkConst.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * _Nonnull LNRequestSerializationErrorDomain;
FOUNDATION_EXPORT NSString * _Nonnull LNResponseSerializationErrorDomain;

typedef NS_ENUM(NSUInteger, LNRequestLocalErrorCode) {
    LNRequestLocalErrorInvalidParams = 3000,//参数错误
    LNRequestLocalErrorInvalidResponseData  = 3001,// 相应无效
    LNRequestLocalErrorInvalidRequestMethod = 3002,// 无效请求方法
    LNRequestLocalErrorInvalidRequestType = 3003, //请求类型无效
    LNRequestLocalErrorInvalidRequestSerializer = 3004, // 无效请求序列化
    LNRequestLocalErrorInvalidResponseSerializer = 3005, // 无效相应序列化
    LNRequestLocalErrorInvalidNetwork = 3006, // 网络连接失败
};


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




@interface LNNetworkConst : NSObject

@end

NS_ASSUME_NONNULL_END
