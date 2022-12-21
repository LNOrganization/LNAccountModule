//
//  LNHTTPRequest.h
//  LNCommonKit
//
//  Created by Lenny on 2021/11/7.
//

#import <Foundation/Foundation.h>
#import "LNNetworkConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNMutiFormData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *mimeType;
@property (nonatomic, strong, nullable) NSData *fileData;
@property (nonatomic, strong, nullable) NSURL *fileURL;

@end


@interface LNHTTPRequest : NSObject

@property(nonatomic, copy)   NSString *urlPath;
@property(nonatomic, copy)   NSDictionary *headers;
@property(nonatomic, copy)   NSDictionary *parameters;
@property(nonatomic, assign) LNRequestType requestType;
@property(nonatomic, assign) LNHTTPMethodType methodType;
@property(nonatomic, assign) LNRequestSerializerType requestSerializerType;
@property(nonatomic, assign) LNResponseSerializerType responseSerializerType;
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, assign) BOOL  isNeedLogin;
@property(nonatomic, strong) NSArray <LNMutiFormData *> *formDatas;
@property(nonatomic, strong) Class responseModelClass;

- (NSString *)method;

- (void)createParameters:(ParametersCreator)parameterCreator;

+ (instancetype)request;


@end


NS_ASSUME_NONNULL_END
