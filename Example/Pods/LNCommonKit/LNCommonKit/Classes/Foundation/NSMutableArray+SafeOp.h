//
//  NSMutableArray+SafeOp.h
//  GCDDemo
//
//  Created by Lenny on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (SafeOp)

- (NSInteger)safe_count;

- (id)safe_objectAtIndex:(NSUInteger)index;

- (NSUInteger)safe_indexOfObject:(id)anObject;

- (NSArray<id> *)safe_objectsAtIndexes:(NSIndexSet *)indexes;

- (void)safe_addObject:(id)anObject;

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)safe_removeLastObject;

- (void)safe_removeObjectAtIndex:(NSUInteger)index;

- (void)safe_removeAllObjects;

- (void)safe_removeObject:(id)anObject;

- (void)safe_removeObject:(id)anObject inRange:(NSRange)range;

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)safe_addObjectsFromArray:(NSArray<id> *)otherArray;

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (NSArray *)safe_copy;


- (void)safe_enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block;

- (void)safe_enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                              usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block;


- (NSArray *)safe_sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr;

- (NSArray *)safe_sortedArrayWithOptions:(NSSortOptions)opts
                         usingComparator:(NSComparator NS_NOESCAPE)cmptr;

- (NSArray *)safe_sortedArrayUsingSelector:(SEL)comparator;

- (void)safe_sortUsingSelector:(SEL)comparator;

- (void)safe_sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr;

- (void)safe_sortWithOptions:(NSSortOptions)opts
             usingComparator:(NSComparator NS_NOESCAPE)cmptr;

@end

NS_ASSUME_NONNULL_END
