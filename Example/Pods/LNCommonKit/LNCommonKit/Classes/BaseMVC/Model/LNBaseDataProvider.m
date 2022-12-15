//
//  LNBaseDataProvider.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import "LNBaseDataProvider.h"
@interface LNBaseDataProvider ()

@property(nonatomic, weak) id<LNChildDataProviderDelegate> child;

@property(nonatomic, assign, readwrite) BOOL isLoading;

@end

@implementation LNBaseDataProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoading = NO;
    }
    return self;
}



+ (instancetype)provider
{
    return [[[self class] alloc] init];
}

+ (instancetype)loadWithCreator:(LNDataProviderCreator)creator
                        success:(LNLoadSuccessBlock)success
                        failure:(LNLoadFailureBlock)failure
{
    LNBaseDataProvider *provider = [[self class] provider];
    LNSafeBlockCall(creator, provider);
    __weak typeof(provider) weakProvider = provider;
    provider.isLoading = true;
    provider.request = [provider requestWithSuccess:^(id  _Nonnull data) {
        [weakProvider handleData:data success:success];
    } failure:^(NSError * _Nonnull error) {
        [weakProvider handleError:error failure:failure];
    }];
    return provider;
}

- (void)handleData:(id)data success:(LNLoadSuccessBlock)success
{
    self.isLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        LNSafeBlockCall(success, data);
    });
}

- (void)handleError:(NSError *)error failure:(LNLoadFailureBlock)failure
{
    self.isLoading = NO;
    NSString *errMsg = [self errMsgWithError:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        LNSafeBlockCall(failure, errMsg);
    });

}

- (LNHTTPRequest *)requestWithSuccess:(LNRequestSuccessBlock)success
                              failure:(LNRequestFailureBlock)failure
{
    NSLog(@"This method need to be overwrite");
    return nil;
}

/*
 * 取消请求
 */
- (void)cancelRequestIfNeed
{
    [LNRequestManager cancelRequest:self.request];
}


- (NSString *)errMsgWithError:(NSError *)error
{
    return @"网络请求失败";
}


@end
