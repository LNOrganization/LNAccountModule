//
//  LNResponse.m
//  LNCommonKit
//
//  Created by Lenny on 2022/12/20.
//

#import "LNResponse.h"
#import "LNJSONModel.h"

@implementation LNResponse


+ (instancetype)responseWithData:(id)data
                         message:(NSString *)message
                            code:(NSInteger)code
{
    return [[LNResponse alloc] initWithData:data message:message code:code];
}

+ (instancetype)responseWithError:(NSError *)error
{
    return [[self alloc] initWithError: error];
}

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self) {
        _error = error;
    }
    return self;
}

- (instancetype)initWithData:(id)data
                     message:(NSString *)message
                        code:(NSInteger)code
{
    self = [super init];
    if (self) {
        _data = data;
        _message = message;
        _code = code;
    }
    return self;
}

- (BOOL)isSucceed
{
    return 200 == self.code && self.data;
}

@end


@implementation LNJSONResponse

+ (instancetype)responseWithDictionary:(NSDictionary *)dict
                            modelClass:(Class)modelClass
{
    return [[[self class] alloc] initWithDictionary:dict modelClass:modelClass];
}


- (instancetype)initWithDictionary:(NSDictionary *)dict
                        modelClass:(Class)modelClass
{
    self = [super init];
    if (self) {
        if([dict isKindOfClass:[NSDictionary class]]){
            self.code = [[dict objectForKey:@"code"] integerValue];
            self.message = [dict objectForKey:@"message"];
            NSDictionary *dataDict = [dict objectForKey:@"data"];
            NSError *error = nil;
            if(dataDict && [modelClass isKindOfClass:[JSONModel class]]){
                self.data = [[modelClass alloc] initWithDictionary:dataDict error:&error];
            }else{
                self.data = dataDict;
            }
            self.error = error;
        }
    }
    return self;
}


@end

@implementation LNListJSONResponse

- (instancetype)initWithDictionary:(NSDictionary *)dict
                        modelClass:(Class)modelClass
{
    self = [super init];
    if (self) {
        if([dict isKindOfClass:[NSDictionary class]]){
            self.code = [[dict objectForKey:@"code"] integerValue];
            self.message = [dict objectForKey:@"message"];
            NSArray *dataList = [dict objectForKey:@"data"];
            NSError *error = nil;
            if([dataList isKindOfClass:[NSArray class]] && [modelClass conformsToProtocol:@protocol(AbstractJSONModelProtocol)]){
                NSArray *models = [modelClass arrayOfModelsFromDictionaries:dataList error:&error];
                self.dataList = [models copy];
            }else{
                self.data = dataList;
            }
            self.error = error;
        }
    }
    return self;
}

- (BOOL)isSucceed
{
    return 200 == self.code && [self.dataList isKindOfClass:[NSArray class]];
}

@end


@implementation LNGroupJSONResponse

+ (instancetype)responseWithDictionary:(NSDictionary *)dict
                            modelClass:(Class)modelClass
                              sections:(NSArray *)sections
{
    return [[[self class] alloc] initWithDictionary:dict
                                         modelClass:modelClass
                                           sections:sections];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
                        modelClass:(Class)modelClass
                          sections:(NSArray *)sections
{
    self = [super init];
    if (self) {
        if([dict isKindOfClass:[NSDictionary class]]){
            self.code = [[dict objectForKey:@"code"] integerValue];
            self.message = [dict objectForKey:@"message"];
            id dataDict = [dict objectForKey:@"data"];
            NSError *error = nil;
            if([sections isKindOfClass:[NSArray class]] && [dataDict isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary *modelsDict = [NSMutableDictionary dictionary];
                for (id<NSCopying> key in sections) {
                    NSArray *dataList = [dataDict objectForKey:key];
                    if([dataList isKindOfClass:[NSArray class]] && [modelClass isKindOfClass:[JSONModel class]]){
                        NSArray *models = [modelClass arrayOfModelsFromDictionaries:dataList error:&error];
                        if([models isKindOfClass:[NSArray class]]){
                            [modelsDict setObject:[models copy] forKey:key];
                        }
                    }
                }
                self.dataDict = [modelsDict copy];
            }else{
                self.dataDict = dataDict;
            }
            self.data = dataDict;
            self.error = error;
        }
    }
    return self;
}

- (BOOL)isSucceed
{
    return 200 == self.code && [self.dataDict isKindOfClass:[NSDictionary class]];
}

@end
