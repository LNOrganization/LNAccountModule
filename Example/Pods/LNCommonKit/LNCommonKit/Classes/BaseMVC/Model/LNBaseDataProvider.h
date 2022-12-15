//
//  LNBaseDataProvider.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "LNRequestManager.h"

@class LNBaseDataProvider;

#define LNSafeBlockCall(Block, ...) ({ !Block ? nil : Block(__VA_ARGS__); })
typedef void(^LNLoadSuccessBlock)(id _Nullable data);
typedef void(^LNLoadFailureBlock)(NSString * _Nullable errMsg);
/** provider构造器，参数provider为LNBaseDataProvider的子类对象*/
typedef void (^LNDataProviderCreator)(id _Nonnull provider);

NS_ASSUME_NONNULL_BEGIN

@protocol LNChildDataProviderDelegate <NSObject>

/** 需要子类重写*/
- (LNHTTPRequest *)requestWithSuccess:(LNRequestSuccessBlock)success
                              failure:(LNRequestFailureBlock)failure;

@end

@interface LNBaseDataProvider : NSObject<LNChildDataProviderDelegate>

@property(nonatomic, strong) LNHTTPRequest *request;

@property(nonatomic, assign, readonly) BOOL isLoading;


+ (instancetype)provider;

+ (instancetype)loadWithCreator:(LNDataProviderCreator)creator
                        success:(LNLoadSuccessBlock)success
                        failure:(LNLoadFailureBlock)failure;

/** 需要子类重写*/
- (LNHTTPRequest *)requestWithSuccess:(LNRequestSuccessBlock)success
                              failure:(LNRequestFailureBlock)failure;

/*
 * 取消请求
 */
- (void)cancelRequestIfNeed;


@end

NS_ASSUME_NONNULL_END
