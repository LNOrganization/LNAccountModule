//
//  LNFeedHTTPClient.h
//  LNFeedModule
//
//  Created by Lenny on 2021/11/8.
//



#import "LNHTTPRequest.h"


typedef void(^LNRequestCompletionBlock)(id _Nullable data, NSError * _Nullable error);
typedef void(^LNRequestProgressBlock)(NSProgress * _Nonnull progress);


@protocol LNHTTPClientDelegate <NSObject>
@optional
/** 子类根据需要可以重写自定义 NSURLSessionDataTask*/
- (NSURLSessionDataTask *_Nullable)dataTaskWithRequest:(nonnull LNHTTPRequest *)request
                                     progress:(LNRequestProgressBlock _Nullable )progress
                                   completion:(nonnull LNRequestCompletionBlock)completion;
                    
@end


@interface LNHTTPClient : NSObject

+ (LNHTTPClient *_Nonnull)client;

@end

