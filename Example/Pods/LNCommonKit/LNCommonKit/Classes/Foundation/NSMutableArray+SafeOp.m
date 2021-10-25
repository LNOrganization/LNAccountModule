//
//  NSMutableArray+SafeOp.m
//  GCDDemo
//
//  Created by Lenny on 2021/8/23.
//

#import "NSMutableArray+SafeOp.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>

static void *kSafeMutableArrayQueueSpecific = &kSafeMutableArrayQueueSpecific;
static void *kSafeMutableArrayQueueKey = &kSafeMutableArrayQueueKey;


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
        dispatch_queue_set_specific(queue, kSafeMutableArrayQueueSpecific, kSafeMutableArrayQueueSpecific, NULL);
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
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (anObject) {
            [self removeObject:anObject];
        }
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
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (anObject && index < self.count) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

- (void)safe_addObjectsFromArray:(NSArray<id> *)otherArray
{
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (otherArray && [otherArray isKindOfClass:[NSArray class]]) {
            [self addObjectsFromArray:otherArray];
        }
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
    ln_safe_op_arr_write(self.operationQueue, ^{
        if (anObject && (range.length + range.location < self.count)) {
            [self removeObject:anObject inRange:range];
        }
    });
}

@end
