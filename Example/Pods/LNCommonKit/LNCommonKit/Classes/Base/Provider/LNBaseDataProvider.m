//
//  LNBaseDataProvider.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import "LNBaseDataProvider.h"
#import "LNConsttant.h"
#import "LNNetworkManager.h"
#import "LNResponse.h"

@interface LNBaseDataProvider ()

@property(nonatomic, weak) id<LNDataProviderAdaptor> child;

@property(nonatomic, assign, readwrite) BOOL isLoading;

@end

@implementation LNBaseDataProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoading = NO;
        self.child = (id)self;
    }
    return self;
}


+ (instancetype)provider
{
    return [[[self class] alloc] init];
}

+ (instancetype)loadWithCreator:(LNDataProviderCreator)creator
                     completion:(_Nullable LNDataLoadCompletionBlock)completion
{
    NSAssert(creator != nil, @"Creator must not be nil");
    LNBaseDataProvider *provider = [[self class] provider];
    creator(provider);
    __weak typeof(provider) weakProvider = provider;
    provider.isLoading = YES;
    provider.request = [provider.child requestWithSuccess:^(id _Nonnull data) {
        
        __weak typeof(weakProvider) strongProvider = weakProvider;
        LNResponse *response = data;
        if([data isKindOfClass:[NSDictionary class]]){
            response = [LNJSONResponse responseWithDictionary:data modelClass:[strongProvider modelClass]];
        }
        [strongProvider handleResponse:response completion:completion];
    } failure:^(NSError * _Nonnull error) {
        [weakProvider handleError:error completion:completion];
    }];
    return provider;
}


- (void)handleResponse:(LNResponse *)response
            completion:(LNDataLoadCompletionBlock)success
{
    self.isLoading = NO;
    BOOL isSucceed = YES;
    id data = response.data;
    NSString *msg = @"请求成功";
    if(!response){
        isSucceed = NO;
        msg = @"暂无数据";
    }else{
        isSucceed = [response isSucceed];
        msg = response.message;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        LN_SAFE_BLOCK_CALL(success, isSucceed, data, msg);
    });
}

- (void)handleError:(NSError *)error
         completion:(LNDataLoadCompletionBlock)failure
{
    self.isLoading = NO;
    NSString *errMsg = [self errMsgWithError:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        LN_SAFE_BLOCK_CALL(failure, NO, nil, errMsg);
    });

}

#pragma mark - LNDataProviderAdaptor

- (LNHTTPRequest *)requestWithSuccess:(LNLoadSuccessBlock)success
                              failure:(LNLoadFailureBlock)failure
{
    NSAssert(NO, @"This method has to overwrite by subclass");
    return nil;
}

/** Response object class*/
- (Class)responseClass
{
    return [LNJSONResponse class];
}

/** Data model class*/
- (Class)modelClass
{
    NSAssert(NO, @"This method has to overwrite by subclass");
    return nil;
}

/*
 * 取消请求
 */
- (void)cancelRequestIfNeed
{
    [LNNetworkManager cancelRequest:self.request];
}


- (NSString *)errMsgWithError:(NSError *)error
{
    return @"网络请求失败";
}


@end
