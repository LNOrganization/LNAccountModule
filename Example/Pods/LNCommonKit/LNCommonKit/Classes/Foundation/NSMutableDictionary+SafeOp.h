//
//  NSMutableDictionary+SafeOp.h
//  GCDDemo
//
//  Created by Lenny on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (SafeOp)

- (NSInteger)safe_count;

- (id)safe_objectForKey:(NSString *)key;

- (NSArray <NSString *>*)safe_allKeys;

- (NSArray<NSString *> *)safe_allKeysForObject:(id)anObject;

- (NSArray <NSString *>*)safe_allValues;

- (NSString *)safe_description;

- (void)safe_removeObjectForKey:(NSString *)key;

- (void)safe_setObject:(id)object forKey:(NSString *)key;

- (void)safe_addEntriesFromDictionary:(NSDictionary<NSString *, id> *)otherDictionary;

- (void)safe_removeAllObjects;

- (void)safe_removeObjectsForKeys:(NSArray<NSString *> *)keyArray;

- (void)safe_setDictionary:(NSDictionary<NSString *, id> *)otherDictionary;


- (void)safe_enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id<NSCopying>key, id obj, BOOL *stop))block;

- (void)safe_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts
                                     usingBlock:(void (NS_NOESCAPE ^)(id<NSCopying> key, id obj, BOOL *stop))block;

- (NSArray *)safe_keysSortedByValueUsingComparator:(NSComparator NS_NOESCAPE)cmptr;

- (NSArray *)safe_keysSortedByValueWithOptions:(NSSortOptions)opts
                               usingComparator:(NSComparator NS_NOESCAPE)cmptr;

- (NSArray *)safe_keysSortedByValueUsingSelector:(SEL)comparator;

@end

NS_ASSUME_NONNULL_END
