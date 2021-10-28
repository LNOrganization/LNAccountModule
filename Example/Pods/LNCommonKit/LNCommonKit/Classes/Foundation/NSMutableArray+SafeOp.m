//
//  NSMutableArray+SafeOp.m
//  GCDDemo
//
//  Created by Lenny on 2021/8/23.
//

#import "NSMutableArray+SafeOp.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>

static void *kLNSafeMutableArrayQueueSpecific = &kLNSafeMutableArrayQueueSpecific;
static void *kLNSafeMutableArrayQueueKey = &kLNSafeMutableArrayQueueKey;


static inline void ln_safe_op_arr_write(dispatch_queue_t queue, void (^block)(void)){
    
    dispatch_barrier_sync(queue, ^{
        block();
    });
}

static inline id ln_safe_op_arr_read(dispatch_queue_t queue, id (^block)(void)){
    __block id data = nil;
    dispatch_sync(queue, ^{
        data = block();
    });
    return data;
}

//    if (dispatch_get_specific(kSafeMutableArrayQueueSpecific) == kSafeMutableArrayQueueSpecific) {
//        data = block();
//    }else{
//        dispatch_sync(queue, ^{
//            data = block();
//        });
//    }

@interface NSMutableArray ()

@end

@implementation NSMutableArray (SafeOp)

#pragma mark - private method
- (dispatch_queue_t)operationQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.djx.GCDDemo.NSMutableArray", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queue, kLNSafeMutableArrayQueueSpecific, kLNSafeMutableArrayQueueSpecific, NULL);
    });
     return queue;
}

- (NSInteger)safe_count
{
    NSNumber *countNum = ln_safe_op_arr_read(self.operationQueue, ^id{
    
        return @(self.count);
    });
    return [countNum integerValue];
}

- (id)safe_objectAtIndex:(NSUInteger)index
{
    id object = ln_safe_op_arr_read(self.operationQueue, ^id{
        if (index >= self.count) {
            return nil;
        }
        return [self objectAtIndex:index];
    });
    return object;
}

- (NSUInteger)safe_indexOfObject:(id)anObject
{
    NSNumber *indexNum = ln_safe_op_arr_read(self.operationQueue, ^id{
        NSInteger index = [self indexOfObject:anObject];
        return @(index);
    });
    return [indexNum integerValue];
}

- (NSArray<id> *)safe_objectsAtIndexes:(NSIndexSet *)indexes
{
    if (!indexes || ![indexes isKindOfClass:[NSIndexSet class]]) {
        return nil;
    }
    NSArray *array = ln_safe_op_arr_read(self.operationQueue, ^id{
        
        return [self objectsAtIndexes:indexes];
    });
    return array;
}

- (void)safe_addObject:(id)anObject
{
    if (!anObject) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self addObject:anObject];
    });
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (index <= self.count) {
            [self insertObject:anObject atIndex:index];
        }
    });
}

- (void)safe_removeLastObject
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self removeLastObject];
    });
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (index < self.count) {
            [self removeObjectAtIndex:index];
        }
    });
}

- (void)safe_removeObject:(id)anObject
{
    if (!anObject) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self removeObject:anObject];
    });
}

- (void)safe_removeAllObjects
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self removeAllObjects];
    });
    
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (!anObject) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (index < self.count) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

- (void)safe_addObjectsFromArray:(NSArray<id> *)otherArray
{
    if (!otherArray || ![otherArray isKindOfClass:[NSArray class]]) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self addObjectsFromArray:otherArray];
    });
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (idx1 < self.count && idx2 < self.count) {
            [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    });
    
}

- (void)safe_removeObject:(id)anObject inRange:(NSRange)range
{
    if (!anObject) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (range.length + range.location < self.count) {
            [self removeObject:anObject inRange:range];
        }
    });
}

- (NSArray *)safe_copy
{
    return ln_safe_op_arr_read(self.operationQueue, ^id{
        return [self copy];
    });
}

- (void)safe_enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block
{
    if (!block) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self enumerateObjectsUsingBlock:block];
    });
}

- (void)safe_enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                              usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block
{
    if (!block) {
        return;
    }
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self enumerateObjectsWithOptions:opts usingBlock:block];
    });
}


- (NSArray *)safe_sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    if (!cmptr) {
        return nil;
    }
    return ln_safe_op_arr_read(self.operationQueue, ^{
        return [self sortedArrayUsingComparator:cmptr];
    });
}

- (NSArray *)safe_sortedArrayWithOptions:(NSSortOptions)opts
                         usingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    if (!cmptr) {
        return nil;
    }
    return ln_safe_op_arr_read(self.operationQueue, ^id{
        return [self sortedArrayWithOptions:opts usingComparator:cmptr];
    });
}

- (NSArray *)safe_sortedArrayUsingSelector:(SEL)comparator
{
    if(!comparator) return nil;
    return ln_safe_op_arr_read(self.operationQueue, ^{
        return [self sortedArrayUsingSelector:comparator];
    });
}

- (void)safe_sortUsingSelector:(SEL)comparator
{
    if(!comparator) return;
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self sortUsingSelector:comparator];
    });
}

- (void)safe_sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    if(!cmptr) return;
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self sortUsingComparator:cmptr];
    });
}

- (void)safe_sortWithOptions:(NSSortOptions)opts
             usingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    if(!cmptr) return;
    ln_safe_op_arr_write(self.operationQueue, ^{
        [self sortWithOptions:opts usingComparator:cmptr];
    });
}
@end
