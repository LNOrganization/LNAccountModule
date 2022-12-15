//
//  LNHTTPRequest.m
//  LNAccountModule
//
//  Created by Lenny on 2021/11/7.
//

#import "LNHTTPRequest.h"



NSString *LNHTTPMethodWithType(LNHTTPMethodType type){
    switch (type) {
        case LNHTTPMethodTypeGet:
            return @"GET";
            break;
        case LNHTTPMethodTypePost:
            return @"POST";
            break;
        case LNHTTPMethodTypePut:
            return @"PUT";
            break;
        case LNHTTPMethodTypeDelete:
            return @"DELETE";
            break;
        case LNHTTPMethodTypeHead:
            return @"HEAD";
            break;
        case LNHTTPMethodTypePatch:
            return @"PATCH";
            break;
        default:
            return nil;
            break;
    }
    return @"GET";
}

NSString *LNURLPathWithBaseURLAppendPath(NSString *host, NSString *path)
{
    if (!path) {
        path = @"";
    }else if (![path hasPrefix:@"/"]) {
        path = [@"/" stringByAppendingString:path];
    }
    return [NSString stringWithFormat:@"%@%@", host, path];
}


@implementation LNMutiFormData

@end

@interface LNHTTPRequest ()

@property(nonatomic, copy) NSString *method;

@end


@implementation LNHTTPRequest


- (NSString *)method {
    if (!_method) {
        _method = LNHTTPMethodWithType(self.methodType);
    }
    return _method;
}

+ (instancetype)request
{
    return [[LNHTTPRequest alloc] init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestType = LNRequestNormal;
        _responseSerializerType = LNResponseSerializerJSON;
        _requestSerializerType = LNRequestSerializerHTTP;
        _methodType = LNHTTPMethodTypeGet;
        _timeoutInterval = 60;
        _isNeedLogin = NO;
    }
    return self;
}

- (void)createParameters:(ParametersCreator)parameterCreator
{
    if (parameterCreator) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        parameterCreator(params);
        _parameters = [params copy];
    }
}


@end
