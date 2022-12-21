//
//  LNHTTPRequest.m
//  LNCommonKit
//
//  Created by Lenny on 2021/11/7.
//

#import "LNHTTPRequest.h"

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
