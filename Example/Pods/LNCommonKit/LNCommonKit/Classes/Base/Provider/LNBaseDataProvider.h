//
//  LNBaseDataProvider.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "LNDataProviderAdaptor.h"

NS_ASSUME_NONNULL_BEGIN


@class LNBaseDataProvider;

/** provider构造器，参数provider为LNBaseDataProvider的子类对象*/
typedef void (^LNDataProviderCreator)(id _Nonnull provider);

typedef void(^LNDataLoadCompletionBlock)(BOOL isSucceed,  id _Nullable data, NSString *errMsg);


@class LNHTTPRequest;
@interface LNBaseDataProvider : NSObject<LNDataProviderAdaptor>

@property(nonatomic, strong) LNHTTPRequest *request;

@property(nonatomic, assign, readonly) BOOL isLoading;


+ (instancetype)provider;

+ (instancetype)loadWithCreator:(LNDataProviderCreator)creator
                     completion:(_Nullable LNDataLoadCompletionBlock)completion;

/*
 * 取消请求
 */
- (void)cancelRequestIfNeed;


@end

NS_ASSUME_NONNULL_END
