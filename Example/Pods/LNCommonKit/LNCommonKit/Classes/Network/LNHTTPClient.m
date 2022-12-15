//
//  LNFeedHTTPClient.m
//  LNFeedModule
//
//  Created by Lenny on 2021/11/8.
//

#import "LNHTTPClient.h"
#import <AFNetworking/AFNetworking.h>
#import "LNNetworkConst.h"

@interface LNHTTPClient ()

@property(nonatomic, strong) dispatch_queue_t completionQueue;
@property(nonatomic, strong) AFHTTPSessionManager     *manager;
@property(nonatomic, strong) AFHTTPResponseSerializer *jsonResponseSerializer;
@property(nonatomic, strong) AFHTTPResponseSerializer *xmlParserResponseSerializer;

@end

@implementation LNHTTPClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _completionQueue = dispatch_queue_create("com.Lenny.HTTPClient.completion.queue", DISPATCH_QUEUE_CONCURRENT);
        _manager = [AFHTTPSessionManager manager];
        _manager.completionQueue = self.completionQueue;
    }
    return self;
}

+ (LNHTTPClient *)client
{
    return [[[self class] alloc] init];
}

#pragma mark - LNClientChildDelegate

- (NSURLSessionDataTask *)dataTaskWithRequest:(nonnull LNHTTPRequest *)request
                                     progress:(LNRequestProgressBlock)progress
                                   completion:(LNRequestCompletionBlock)completion
{
    NSString *httpMethod = [request method];
    if (!httpMethod) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The `method type`  is not valid method.", NSStringFromClass([self class]), nil)};
        [self handleResponseResult:nil
                            object:nil
                             error:[NSError errorWithDomain:LNRequestSerializationErrorDomain code:LNRequestLocalErrorInvalidRequestMethod userInfo:userInfo]
                           request:request
                        completion:completion];
        return nil;
    }
    if (request.requestType == LNRequestUpload) {
        return [self _uploadTaskWithRequest:request progress:progress completion:completion];
    }else{
        return [self _dataTaskWithRequest:request completion:completion];
    }
}


#pragma mark - private method


- (NSURLSessionDataTask *)_dataTaskWithRequest:(nonnull LNHTTPRequest *)request
                                    completion:(LNRequestCompletionBlock)completion

{
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];

    NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:[request method]
                                                                 URLString:request.urlPath
                                                                parameters:request.headers
                                                                     error:&serializationError];
    if (serializationError) {
        [self handleResponseResult:nil
                            object:nil
                             error:serializationError
                           request:request
                        completion:completion
         ];
        return nil;
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:urlRequest
                                    uploadProgress:nil
                                  downloadProgress:nil
                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [strongSelf handleResponseResult:response
                                                               object:responseObject
                                                                error:error
                                                              request:request
                                                           completion:completion
                                      ];
                                 }];
    return dataTask;
}

- (NSURLSessionDataTask *)_uploadTaskWithRequest:(nonnull LNHTTPRequest *)request
                                        progress:(LNRequestProgressBlock)progress
                                      completion:(LNRequestCompletionBlock)completion
{
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    __block NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest = [requestSerializer multipartFormRequestWithMethod:[request method]
                                                                              URLString:request.urlPath
                                                                             parameters:request.parameters
                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              [request.formDatas enumerateObjectsUsingBlock:^(LNMutiFormData *obj, NSUInteger idx, BOOL *stop) {
                  if (obj.fileData) {
                      if (obj.fileName && obj.mimeType) {
                          [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                      } else {
                          [formData appendPartWithFormData:obj.fileData name:obj.name];
                      }
                  } else if (obj.fileURL) {
                      NSError *fileError = nil;
                      if (obj.fileName && obj.mimeType) {
                          [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&fileError];
                      } else {
                          [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&fileError];
                      }
                      if (fileError) {
                          serializationError = fileError;
                          *stop = YES;
                      }
                  }
              }];
        } error:&serializationError];
    
    if (serializationError) {
        [self handleResponseResult:nil
                            object:nil
                             error:serializationError
                           request:request
                        completion:completion];
        return nil;
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionUploadTask *uploadTask = nil;
    uploadTask = [_manager uploadTaskWithStreamedRequest:urlRequest
                                                progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
                    
                                            }
                                       completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleResponseResult:response
                            object:responseObject
                             error:error
                           request:request
                              completion:completion
         ];
                                           
                }];
    return uploadTask;
}



- (AFHTTPRequestSerializer *)requestSerializerForRequest:(LNHTTPRequest *)request
{
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == LNRequestSerializerHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if(request.requestSerializerType == LNRequestSerializerJSON){
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = request.timeoutInterval;
    if (request.headers.count > 0) {
        [request.headers enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
    
    return requestSerializer;
}

#pragma mark - response

- (AFHTTPResponseSerializer *)responseSerializerForRequest:(LNHTTPRequest *)request{
    if (request.responseSerializerType == LNResponseSerializerJSON) {
        return self.jsonResponseSerializer;
    }else if(request.responseSerializerType == LNResponseSerializerXMLParser){
        return self.xmlParserResponseSerializer;
    }else{
        return nil;
    }
}

- (void)handleResponseResult:(NSURLResponse *)response
                      object:(id)responseObject
                       error:(NSError *)error
                     request:(LNHTTPRequest *)request
                  completion:(LNRequestCompletionBlock)completion
{
    
    if (!error) {
        if (responseObject) {
            NSError *responseError = nil;
            if (request.responseSerializerType != LNResponseSerializerHTTP) {
                AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:request];
                responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&responseError];
            }
            error = responseError;
        }else{
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The `responseObject`  is nil.", NSStringFromClass([self class]), nil)};
            error = [NSError errorWithDomain:LNResponseSerializationErrorDomain code:LNRequestLocalErrorInvalidResponseData userInfo:userInfo];
        }

    }
    if (completion) {
        completion(responseObject, error);
    }
}


@end

