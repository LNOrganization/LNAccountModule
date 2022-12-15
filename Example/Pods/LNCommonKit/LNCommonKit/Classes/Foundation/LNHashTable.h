//
//  LNHashTable.h
//  LNCommonKit
//
//  Created by Lenny on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNHashTable : NSObject


@property (readonly) NSUInteger count;

@property (readonly, copy) NSArray<id> *allObjects;    // convenience

@property (nullable, nonatomic, readonly) id anyObject;


- (nullable id)member:(nullable id)object;
- (instancetype)initWithOptions:(NSPointerFunctionsOptions)options capacity:(NSUInteger)initialCapacity;

- (void)addObject:(nullable id)object;
- (void)removeObject:(nullable id)object;

- (void)removeAllObjects;

- (BOOL)containsObject:(nullable id)anObject;

- (NSEnumerator<id> *)objectEnumerator;

@end

NS_ASSUME_NONNULL_END
