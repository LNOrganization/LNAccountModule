//
//  LNRequestManager.m
//  LNFeedModule
//
//  Created by Lenny on 2022/12/3.
//

#import "LNRequestManager.h"
#import "LNHTTPClient.h"
#import <objc/runtime.h>

#define LN_NET_SAFE_BLOCK(Block, ...) ({ !Block ? nil : Block(__VA_ARGS__); })

static void *kLNRequestIDBindingKey = &kLNRequestIDBindingKey;

@interface LNHTTPRequest (LNTaskIDBinding)

@property(nonatomic, copy) NSString *requestId;

@end

@implementation LNHTTPRequest (LNTaskIDBinding)

- (void)setRequestId:(NSString *)requestId
{
    objc_setAssociatedObject(self, kLNRequestIDBindingKey, requestId, OBJC_ASSOCIATION_COPY);
}

- (NSString *)requestId
{
    return objc_getAssociatedObject(self, kLNRequestIDBindingKey);
}

@end

@interface LNRequestManager ()


@property(nonatomic, strong) NSMutableDictionary *requests;
@property(nonatomic, strong) dispatch_queue_t requestQueue;

@end

@implementation LNRequestManager

+ (LNRequestManager *)sharedInstance
{
    static LNRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return  instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requests = [[NSMutableDictionary alloc] init];
        _requestQueue = dispatch_queue_create("com.Lenny.LNRequestManager.request.queue", DISPATCH_QUEUE_CONCURRENT);
        _requestConfig =  [LNRequestConfig sharedInstance];
        _httpClient = (id)[LNHTTPClient client];        
    }
    return self;
}


#pragma mark - public method

+ (LNHTTPRequest *)startRequestCreator:(LNRequestCreator)requestCreator
                               succeed:(LNRequestSuccessBlock)succeedBlock
                                failed:(LNRequestFailureBlock)failedBlock
{
    LNHTTPRequest * request = [LNHTTPRequest request];
    if (requestCreator) {
        requestCreator(request);
    }
    [[self sharedInstance] _startRequest:request
                                progress:nil
                                 succeed:succeedBlock
                                  failed:failedBlock];
    return request;
}

+ (LNHTTPRequest *)startRequestCreator:(LNRequestCreator)requestCreator
                              progress:(LNRequestProgressBlock)progressBlock
                               succeed:(LNRequestSuccessBlock)succeedBlock
                                failed:(LNRequestFailureBlock)failedBlock
{
    LNHTTPRequest * request = [LNHTTPRequest request];
    if (requestCreator) {
        requestCreator(request);
    }
    [[self sharedInstance] _startRequest:request
                                progress:progressBlock
                                 succeed:succeedBlock
                                  failed:failedBlock];
    return request;
}

+ (void)startRequest:(LNHTTPRequest *)request
             succeed:(LNRequestSuccessBlock)succeedBlock
              failed:(LNRequestFailureBlock)failedBlock
{
    [[self sharedInstance] _startRequest:request
                                progress:nil
                                 succeed:succeedBlock
                                  failed:failedBlock];
}

+ (void)startRequest:(LNHTTPRequest *)request
            progress:(LNRequestProgressBlock)progressBlock
             succeed:(LNRequestSuccessBlock)succeedBlock
              failed:(LNRequestFailureBlock)failedBlock
{
    [[self sharedInstance] _startRequest:request
                                progress:progressBlock
                                 succeed:succeedBlock
                                  failed:failedBlock];
}


+ (void)cancelRequest:(LNHTTPRequest *)request
{
    [[self sharedInstance] _cancelRequest:request];
}


#pragma mark - private method
- (void)_startRequest:(nonnull LNHTTPRequest *)request
             progress:(LNRequestProgressBlock)progressBlock
              succeed:(LNRequestSuccessBlock)succeedBlock
               failed:(LNRequestFailureBlock)failedBlock
{
    
    [self _configRequest:request];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.httpClient dataTaskWithRequest:request
                                                            progress:^(NSProgress *progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleProgress:progress request:request block:progressBlock];
        
    } completion:^(id data, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponse:data
                             error:error
                           request:request
                           succeed:succeedBlock
                            failed:failedBlock];
    }];
    request.requestId = [NSString stringWithFormat:@"%@",@(dataTask.taskIdentifier)];
    [self saveRequest:request withTask:dataTask];//缓存请求对象，方便取消请求操作
    [dataTask resume];
    
}

- (void)_cancelRequest:(LNHTTPRequest *)request
{
    [self removeRequest:request];
}

- (void)_configRequest:(LNHTTPRequest *)request
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (self.requestConfig.commonHeaders) {
        [headers addEntriesFromDictionary:self.requestConfig.commonHeaders];
    }
    if (request.headers) {
        [headers addEntriesFromDictionary:request.headers];
    }
    request.headers = [headers copy];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.requestConfig.commonParameters) {
        [parameters addEntriesFromDictionary:self.requestConfig.commonParameters];
    }
    if (request.parameters) {
        [parameters addEntriesFromDictionary:request.parameters];
    }
    request.parameters = [parameters copy];
    
    NSString *urlPath = LNURLPathWithBaseURLAppendPath(self.requestConfig.baseURL, request.urlPath);
    request.urlPath = urlPath;
}

#pragma mark -
- (void)handleResponse:(id)data
                 error:(NSError *)error
               request:(LNHTTPRequest *)request
               succeed:(LNRequestSuccessBlock)succeedBlock
                failed:(LNRequestFailureBlock)failedBlock
{
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(_completionQueue, ^{
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//
//        BOOL isValid = [strongSelf isValidRequest:request];
//        if (!isValid) {
//            // 请求无效（取消等），没必要返回
//            return;
//        }
//        if (error) {
//            LN_SAFE_BLOCK(failedBlock, error);
//        }else{
//            LN_SAFE_BLOCK(succeedBlock, data);
//        }
//        [strongSelf removeRequest:request];//请求完毕清理缓存
//    });
    
    BOOL isValid = [self isValidRequest:request];
    if (!isValid) {
        // 请求无效（取消等），没必要返回
        return;
    }
    if (error) {
        LN_NET_SAFE_BLOCK(failedBlock, error);
    }else{
        LN_NET_SAFE_BLOCK(succeedBlock, data);
    }
    [self removeRequest:request];//请求完毕清理缓存
}

- (void)handleProgress:(NSProgress *)progress
               request:(LNHTTPRequest *)request
                 block:(LNRequestProgressBlock)progressBlock
{
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(_completionQueue, ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        BOOL isValid = [strongSelf isValidRequest:request];
//        if (!isValid) {
//            // 请求无效（取消等），没必要返回
//            return;
//        }
//        LN_SAFE_BLOCK(progressBlock, progress);
//    });
    
    BOOL isValid = [self isValidRequest:request];
    if (!isValid) {
        // 请求无效（取消等），没必要返回
        return;
    }
    LN_NET_SAFE_BLOCK(progressBlock, progress);

}


#pragma mark -
- (void)saveRequest:(LNHTTPRequest *)request withTask:(NSURLSessionDataTask *)task
{
    if (!task || !request) {
        return;
    }
    dispatch_barrier_sync(_requestQueue, ^{
        [self.requests setObject:request forKey:request.requestId];
    });
}

- (BOOL)isValidRequest:(LNHTTPRequest *)request
{
    if (!request) {
        return NO;
    }
    __block BOOL isValid = NO;
    dispatch_sync(_requestQueue, ^{
        LNHTTPRequest * ret = [self.requests objectForKey:request.requestId];
        if (ret && ret == request) {
            isValid = YES;
        }
    });
    return isValid;
}

- (void)removeRequest:(LNHTTPRequest *)request
{
    if (!request) {
        return;
    }
    dispatch_barrier_sync(_requestQueue, ^{
        [self.requests removeObjectForKey:request.requestId];
    });
}


@end
