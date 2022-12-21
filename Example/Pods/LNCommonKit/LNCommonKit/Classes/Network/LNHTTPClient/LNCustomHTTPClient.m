//
//  LNCustomHTTPClient.m
//  LNCommonKit
//
//  Created by Lenny on 2022/11/30.
//

#import "LNCustomHTTPClient.h"
#import "LNHTTPRequest.h"

@interface LNCustomHTTPClient ()


@end

@implementation LNCustomHTTPClient

+ (instancetype)client
{
    return [[[self class] alloc] init];
}

#pragma mark - LNClientChildDelegate

- (NSURLSessionDataTask *)dataTaskWithRequest:(nonnull LNHTTPRequest *)request
                                     progress:(LNRequestProgressBlock)progress
                                   completion:(LNRequestCompletionBlock)completion
{
    if (request.requestType == LNRequestUpload) {
        return [self _uploadTaskWithRequest:request completion:completion];
    }else{
        return [self _dataTaskWithRequest:request completion:completion];
    }
}


#pragma mark - NSURLSessionDataTask

- (NSURLSessionDataTask *)_dataTaskWithRequest:(nonnull LNHTTPRequest *)requestAdapter
                                    completion:(LNRequestCompletionBlock)completion
{
    NSMutableURLRequest *httpRequest = [self _requestWithAdapter:requestAdapter completion:completion];

    if(!httpRequest){
        return nil;
    }
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleResponse:response data:data error:error request:requestAdapter completion:completion];
    }];
    return dataTask;
}


- (NSURLSessionDataTask *)_uploadTaskWithRequest:(nonnull LNHTTPRequest *)requestAdapter
                                      completion:(LNRequestCompletionBlock)completion
{
    NSMutableURLRequest *httpRequest = [self httpUploadWithRequest:requestAdapter];
    if (requestAdapter.headers.count > 0) {
        [requestAdapter.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [httpRequest addValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if(!httpRequest){
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"httpRequest is nil", NSStringFromClass([self class]), nil)};
       NSError *error = [[NSError alloc] initWithDomain:LNRequestSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
        return nil;
    }
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleResponse:response data:data error:error request:requestAdapter completion:completion];
    }];
    return dataTask;
}


#pragma mark - NSMutableURLRequest
- (NSMutableURLRequest *)_requestWithAdapter:(nonnull LNHTTPRequest *)request
                                  completion:(LNRequestCompletionBlock)completion

{
    NSMutableURLRequest *httpRequest = nil;

    switch (request.requestSerializerType) {
        case LNRequestSerializerHTTP:
            httpRequest = [self _httpRequestWithAdapter:request completion:completion];
            break;
        case LNRequestSerializerJSON:
            httpRequest = [self _httpJsonRequestWithAdapter:request completion:completion];
            break;
        default:
            httpRequest = [self _httpRequestWithAdapter:request completion:completion];
            break;
    }
    httpRequest.HTTPMethod = [request method];
    httpRequest.timeoutInterval = request.timeoutInterval;
    if (request.headers.count > 0) {
        [request.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [httpRequest addValue:obj forHTTPHeaderField:key];
        }];
    }

    return httpRequest;
}


- (NSMutableURLRequest *)_httpRequestWithAdapter:(nonnull LNHTTPRequest *)request
                                      completion:(LNRequestCompletionBlock)completion
{
    __block NSString *parameterStr = @"";
    NSString *urlString = request.urlPath;
    NSDictionary *parameter = [request parameters];
    if (parameter.count > 0) {
        parameterStr = @"?";
        [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *jsonStr = @"";
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                if (jsonStr) {
                    // 去掉空格
                    jsonStr = [self deleteAllEmptyCharFromStr:jsonStr];
                }
                parameterStr = [parameterStr stringByAppendingFormat:@"%@=%@&",key, jsonStr];
            }else{
                parameterStr = [parameterStr stringByAppendingFormat:@"%@=%@&",key, [obj description]];
            }

        }];
        parameterStr = [parameterStr stringByReplacingCharactersInRange:NSMakeRange(parameterStr.length -1, 1) withString:@""];
    }
    
    urlString = [urlString stringByAppendingString:parameterStr];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *httpRequest = [NSMutableURLRequest requestWithURL:url];
    return httpRequest;
}


- (NSMutableURLRequest *)_httpJsonRequestWithAdapter:(nonnull LNHTTPRequest *)request
                                          completion:(LNRequestCompletionBlock)completion
{
    NSString *urlString = request.urlPath;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *httpRequest = [NSMutableURLRequest requestWithURL:url];
//    [httpRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (![httpRequest valueForHTTPHeaderField:@"Content-Type"]) {
        [httpRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    NSDictionary *parameters = [request parameters];
    NSError *error = nil;
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The `parameters` argument is not valid JSON.", NSStringFromClass([self class]), nil)};
            error = [[NSError alloc] initWithDomain:LNRequestSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            if (completion) {
                completion(nil, error);
            }
            return nil;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[request parameters] options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData || error) {
            if (!error) {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The `parameters` argument JSON serialization error.", NSStringFromClass([self class]), nil)};
                error = [[NSError alloc] initWithDomain:LNRequestSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
            if (completion) {
                completion(nil, error);
            }
            return nil;
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [httpRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return httpRequest;
}


- (NSMutableURLRequest *)httpUploadWithRequest:(nonnull LNHTTPRequest *)requestAdapter
{
    NSURL *url = [NSURL URLWithString:requestAdapter.urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = [requestAdapter method];
    request.timeoutInterval = requestAdapter.timeoutInterval;
    //设置请求实体
    NSMutableData *body = [NSMutableData data];
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:[requestAdapter parameters] options:NSJSONWritingPrettyPrinted error:nil];
    NSString*paramsDataString = [[NSString alloc]initWithData:paramsData encoding:NSUTF8StringEncoding];
     NSMutableString *paramsDataMutiString = [NSMutableString stringWithString:paramsDataString];
    NSRange range = {0,paramsDataString.length};
    //去掉字符串中的空格
    [paramsDataMutiString replaceOccurrencesOfString:@"" withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, paramsDataMutiString.length};
    //去掉字符串中的换行符
    [paramsDataMutiString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    //普通参数
    [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
    //上传参数需要key： （相应参数，在这里是_myModel.personID）
    NSString *dispositions = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",@"content"];
    [body appendData:[self getDataWithString: dispositions]];
    [body appendData:[self getDataWithString: @"\r\n"]];
    [body appendData:[self getDataWithString: paramsDataMutiString]];
    [body appendData:[self getDataWithString: @"\r\n"]];

    for (LNMutiFormData *multiData in [requestAdapter formDatas]) {
        //文件参数
        NSString *imageFormat = @"";
        imageFormat = [NSString stringWithFormat:@"Content-Type: %@ \r\n", multiData.mimeType];
        [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", multiData.name, multiData.fileName];
        [body appendData:[self getDataWithString:disposition ]];

        [body appendData:[self getDataWithString:imageFormat]];
        [body appendData:[self getDataWithString:@"\r\n"]];
        [body appendData:multiData.fileData];
        [body appendData:[self getDataWithString:@"\r\n"]];
    }
    
    //参数结束
    [body appendData:[self getDataWithString:@"--BOUNDARY--\r\n"]];
    request.HTTPBody = body;
    //设置请求体长度
    NSInteger length = [body length];
    [request setValue:[NSString stringWithFormat:@"%ld",length] forHTTPHeaderField:@"Content-Length"];
    //设置 POST请求文件上传
    [request setValue:@"multipart/form-data; boundary=BOUNDARY" forHTTPHeaderField:@"Content-Type"];
    return request;
}


- (NSData *)getDataWithString:(NSString *)str
{
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}



- (NSString *)deleteAllEmptyCharFromStr:(NSString *)str
{
    NSString *result = [str copy];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}

#pragma mark - response
- (void)handleResponse:(NSURLResponse *)response
                  data:(id)data
                 error:(NSError *)error
               request:(nonnull LNHTTPRequest *)request
            completion:(LNRequestCompletionBlock)completion
                                
{
    if (error) {
        if (completion) {
            completion(nil, error);
        }
    }else if(data){
        [self handleResponse:response data:data request:request completion:completion];
    }else{
        NSInteger statusCode = -111;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            statusCode = httpResponse.statusCode;
        }
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The response `data` nil.", NSStringFromClass([self class]), nil)};
        statusCode = statusCode == -111 ? NSURLErrorCannotDecodeContentData: statusCode;
        error = [[NSError alloc] initWithDomain:LNResponseSerializationErrorDomain code:statusCode  userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
    }
}

- (void)handleResponse:(NSURLResponse *)response
                  data:(id)data
               request:(nonnull LNHTTPRequest *)request
            completion:(LNRequestCompletionBlock)completion
{
   
    if (request.responseSerializerType != LNResponseSerializerJSON) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"This LNResponseSerializerType is not support, you can overwrite this method to  support.", NSStringFromClass([self class]), nil)};
        NSError *error = [[NSError alloc] initWithDomain:LNResponseSerializationErrorDomain code:0 userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    NSDictionary *jsonData = nil;
    NSError *error = nil;
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        statusCode = httpResponse.statusCode;
    }
    if ([data isKindOfClass:[NSData class]]) {
        jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The response `data` not valid json data.", NSStringFromClass([self class]), nil)};
            error = [[NSError alloc] initWithDomain:LNResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        }else{
            if (!jsonData) {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The response `jsonData` nil.", NSStringFromClass([self class]), nil)};
                error = [[NSError alloc] initWithDomain:LNResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
       
    }else{
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The response `data` nil.", NSStringFromClass([self class]), nil)};
        error = [[NSError alloc] initWithDomain:LNResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
    }
    if (completion) {
        completion(jsonData, error);
    }

}


@end


