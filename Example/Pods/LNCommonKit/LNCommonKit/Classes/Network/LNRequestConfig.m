//
//  LNRequestConfig.m
//  LNFeedModule
//
//  Created by Lenny on 2022/12/2.
//

#import "LNRequestConfig.h"

@implementation LNRequestConfig

+ (instancetype)sharedInstance
{
    static LNRequestConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return  instance;
}

@synthesize baseURL = _baseURL;

@synthesize commonParameters = _commonParameters;

@synthesize commonUserInfo = _commonUserInfo;

@synthesize commonHeaders = _commonHeaders;


- (NSString *)baseURL
{
    if (!_baseURL) {
        _baseURL = @"https://www.baidu.com";
    }
    return _baseURL;
}

- (NSDictionary *)_commonParameters
{
    if (!_commonParameters) {
        _commonParameters = @{};
    }
    return _commonParameters;
}

- (NSDictionary *)commonHeaders
{
    if (!_commonHeaders) {
        _commonHeaders =  @{};
    }
    return _commonHeaders;
}

- (NSDictionary *)commonUserInfo
{
    if (!_commonUserInfo) {
        _commonUserInfo = @{};
    }
    return _commonUserInfo;
}

@end
