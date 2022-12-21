//
//  LNDataProviderAdaptor.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LNLoadSuccessBlock)(id _Nullable data);
typedef void(^LNLoadFailureBlock)(NSError * _Nullable error);

@protocol LNDataProviderAdaptor <NSObject>
/**
 发起请求
 @return 返回请求对象，可用于取消请求等操作
 */
- (id)requestWithSuccess:(LNLoadSuccessBlock)success
                 failure:(LNLoadFailureBlock)failure;

/**The response object class to create request response*/
- (Class)responseClass;

/**The data model class to create model object*/
- (Class)modelClass;

@end

NS_ASSUME_NONNULL_END
