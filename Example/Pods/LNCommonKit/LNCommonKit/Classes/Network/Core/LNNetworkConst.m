//
//  LNNetworkConst.m
//  LNCommonKit
//
//  Created by Lenny on 2022/12/16.
//

#import "LNNetworkConst.h"

NSString *LNRequestSerializationErrorDomain = @"LNRequestSerializationErrorDomain";
NSString *LNResponseSerializationErrorDomain = @"LNResponseSerializationErrorDomain";

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



@implementation LNNetworkConst

@end
