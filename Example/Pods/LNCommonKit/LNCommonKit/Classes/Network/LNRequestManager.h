//
//  LNRequestManager.h
//  LNFeedModule
//
//  Created by Lenny on 2022/12/3.
//

#import <Foundation/Foundation.h>
#import "LNRequestConfig.h"
#import "LNHTTPRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LNHTTPClientDelegate;

@interface LNRequestManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

typedef void (^LNRequestCreator)(LNHTTPRequest* request);
typedef void (^LNRequestSuccessBlock)(id data);
typedef void (^LNRequestFailureBlock)(NSError *error);
typedef void (^LNRequestProgressBlock)(NSProgress *progress);

+ (LNHTTPRequest *)startRequestCreator:(LNRequestCreator)requestCreator
                               succeed:(LNRequestSuccessBlock)succeedBlock
                                failed:(LNRequestFailureBlock)failedBlock;

+ (LNHTTPRequest *)startRequestCreator:(LNRequestCreator)requestCreator
                              progress:(LNRequestProgressBlock)progressBlock
                               succeed:(LNRequestSuccessBlock)succeedBlock
                                failed:(LNRequestFailureBlock)failedBlock;

+ (void)startRequest:(LNHTTPRequest *)request
             succeed:(LNRequestSuccessBlock)succeedBlock
              failed:(LNRequestFailureBlock)failedBlock;

+ (void)startRequest:(LNHTTPRequest *)request
            progress:(LNRequestProgressBlock)progressBlock
             succeed:(LNRequestSuccessBlock)succeedBlock
              failed:(LNRequestFailureBlock)failedBlock;

+ (void)cancelRequest:(LNHTTPRequest *)request;

@property(nonatomic, strong)   id<LNHTTPClientDelegate> httpClient;

@property(nonatomic, strong) id<LNRequestConfigAdapter> requestConfig;


@end

NS_ASSUME_NONNULL_END
