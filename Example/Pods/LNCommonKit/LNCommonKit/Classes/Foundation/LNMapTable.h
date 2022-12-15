//
//  LNMapTable.h
//  LNCommonKit
//
//  Created by Lenny on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id LNKeyType;
typedef id LNObjectType;

@interface LNMapTable : NSObject

- (instancetype)initWithKeyOptions:(NSPointerFunctionsOptions)keyOptions valueOptions:(NSPointerFunctionsOptions)valueOptions capacity:(NSUInteger)initialCapacity;


- (nullable LNObjectType)objectForKey:(nullable LNKeyType)aKey;

- (void)removeObjectForKey:(nullable LNKeyType)aKey;
- (void)setObject:(nullable LNObjectType)anObject forKey:(nullable LNKeyType)aKey;   // add/replace value (CFDictionarySetValue, NSMapInsert)

@property (readonly) NSUInteger count;

- (NSEnumerator<LNKeyType> *)keyEnumerator;
- (nullable NSEnumerator<LNObjectType> *)objectEnumerator;

- (void)removeAllObjects;

- (NSDictionary<LNKeyType, LNObjectType> *)dictionaryRepresentation;
@end

NS_ASSUME_NONNULL_END
