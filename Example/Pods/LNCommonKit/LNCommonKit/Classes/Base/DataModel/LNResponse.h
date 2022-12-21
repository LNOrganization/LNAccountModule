//
//  LNResponse.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNResponse : NSObject

@property (nonatomic, strong) id data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSError *error;

+ (instancetype)responseWithData:(id)data
                         message:(NSString *)message
                            code:(NSInteger)code;

+ (instancetype)responseWithError:(NSError *)error;

- (instancetype)initWithData:(id)data
                     message:(NSString *)message
                        code:(NSInteger)code;


- (BOOL)isSucceed;

@end



@interface LNJSONResponse : LNResponse


+ (instancetype)responseWithDictionary:(NSDictionary *)dict
                            modelClass:(Class)modelClass;
- (instancetype)initWithDictionary:(NSDictionary *)dict
                        modelClass:(Class)modelClass;

@end

@class JSONModel;
@interface LNListJSONResponse : LNJSONResponse

@property (nonatomic, strong) NSArray <JSONModel *>* dataList;

@end

@interface LNGroupJSONResponse : LNJSONResponse

@property (nonatomic, strong) NSDictionary <id<NSCopying>, NSArray<JSONModel *> *> * dataDict;

@property (nonatomic, strong) NSArray <id<NSCopying>> *sections;

+ (instancetype)responseWithDictionary:(NSDictionary *)dict
                            modelClass:(Class)modelClass
                              sections:(NSArray *)sections;

- (instancetype)initWithDictionary:(NSDictionary *)dict
                        modelClass:(Class)modelClass
                          sections:(NSArray *)sections;

@end




NS_ASSUME_NONNULL_END
