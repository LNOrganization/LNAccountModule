//
//  LNAFNetworkConfig.m
//  LNCommonKit
//
//  Created by Lenny on 2022/12/2.
//

#import "LNAFNetworkConfig.h"
#import <LNCommonKit/LNNetworkConst.h>
#import <LNCommonKit/LNNetworkManager.h>
#import "LNAFNetworkingHTTPClient.h"


@implementation LNAFNetworkConfig

+ (instancetype)sharedInstance
{
    static LNAFNetworkConfig *instance = nil;
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
        [LNNetworkManager sharedInstance].requestConfig = self;
        [LNNetworkManager sharedInstance].httpClient = (id)[LNAFNetworkingHTTPClient client];
    }
    return self;
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
