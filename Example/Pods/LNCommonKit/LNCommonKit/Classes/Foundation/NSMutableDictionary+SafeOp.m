//
//  NSMutableDictionary+SafeOp.m
//  GCDDemo
//
//  Created by Lenny on 2021/8/23.
//

#import "NSMutableDictionary+SafeOp.h"
#import <objc/runtime.h>

#import <pthread/pthread.h>

//static pthread_mutex_t safe_create_dic_lock = PTHREAD_MUTEX_INITIALIZER;


static void *kSafeMutableDictionaryQueueSpecific = &kSafeMutableDictionaryQueueSpecific;
static void *kSafeMutableDictionaryQueueKey = &kSafeMutableDictionaryQueueKey;

static inline void ln_safe_op_dic_write(dispatch_queue_t queue, void (^block)(void)){

    if (dispatch_get_specific(kSafeMutableDictionaryQueueSpecific) == kSafeMutableDictionaryQueueSpecific) {
        block();
    }else{
        dispatch_sync(queue, block);
    }
}

static inline id ln_safe_op_dic_read(dispatch_queue_t queue, id (^block)(void)){
    __block id data = nil;
    if (dispatch_get_specific(kSafeMutableDictionaryQueueSpecific) == kSafeMutableDictionaryQueueSpecific) {
        data = block();
    }else{
        dispatch_sync(queue, ^{
            data = block();
        });
    }
    return data;
}

@interface NSMutableDictionary ()

@property (nonatomic, strong) dispatch_queue_t operationQueue;

@end

@implementation NSMutableDictionary (SafeOp)

- (void)setOperationQueue:(dispatch_queue_t)operationQueue
{
    objc_setAssociatedObject(self, kSafeMutableDictionaryQueueKey, operationQueue, OBJC_ASSOCIATION_RETAIN);
}

- (dispatch_queue_t)operationQueue
{
    dispatch_queue_t operationQueue = objc_getAssociatedObject(self, kSafeMutableDictionaryQueueKey);
    if (!operationQueue) {
        operationQueue = [self safe_creatOperationQueue];
    }
    return operationQueue;
}

//- (dispatch_queue_t)safe_creatOperationQueue
//{
//    dispatch_queue_t operationQueue = nil;
//    pthread_mutex_lock(&safe_create_dic_lock);
//    operationQueue = dispatch_queue_create("com.djx.GCDDemo.LNSafeMutableDictionary", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_set_specific(operationQueue, kSafeMutableDictionaryQueueSpecific, kSafeMutableDictionaryQueueSpecific, NULL);
//    [self setOperationQueue:operationQueue];
//    pthread_mutex_unlock(&safe_create_dic_lock);
////    @synchronized (self) {
////        operationQueue = dispatch_queue_create("com.djx.GCDDemo.LNSafeMutableDictionary", DISPATCH_QUEUE_SERIAL);
////        dispatch_queue_set_specific(operationQueue, kSafeMutableDictionaryQueueSpecific, kSafeMutableDictionaryQueueSpecific, NULL);
////        [self setOperationQueue:operationQueue];
////    }
//    return operationQueue;
//}

- (dispatch_queue_t)safe_creatOperationQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.djx.GCDDemo.NSMutableArray", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queue, kSafeMutableDictionaryQueueSpecific, kSafeMutableDictionaryQueueSpecific, NULL);
    });
     return queue;
}
//

- (NSInteger)safe_count
{
    NSNumber *countNum = ln_safe_op_dic_read(self.operationQueue, ^id{
        NSInteger count = self.count;
        return @(count);
    });
    return [countNum integerValue];
}

- (id)safe_objectForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    id object = ln_safe_op_dic_read(self.operationQueue, ^id{
        return [self objectForKey:key];
    });
    return object;
}

- (NSArray <NSString *>*)safe_allKeys
{
    NSArray *keys = ln_safe_op_dic_read(self.operationQueue, ^id{
        return [self allKeys];
    });
    return keys;
}

- (NSArray<NSString *> *)safe_allKeysForObject:(id)anObject
{
    if (!anObject) {
        return nil;
    }
    NSArray *keys = ln_safe_op_dic_read(self.operationQueue, ^id{
        return [self allKeysForObject:anObject];
    });
    return keys;
}

- (NSArray <NSString *>*)safe_allValues
{
    NSArray *keys = ln_safe_op_dic_read(self.operationQueue, ^id{
        return [self allValues];
    });
    return keys;
}

- (NSString *)description
{
    NSString *description = ln_safe_op_dic_read(self.operationQueue, ^id{
        return [self description];
    });
    return description;
}


- (void)safe_removeObjectForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self removeObjectForKey:key];
    });
}

- (void)safe_setObject:(id)object forKey:(NSString *)key
{
    if (!object || !key) {
        return;
    }
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self setObject:object forKey:key];
    });
}

- (void)safe_addEntriesFromDictionary:(NSDictionary<NSString *, id> *)otherDictionary
{
    if (!otherDictionary || ![otherDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self addEntriesFromDictionary:otherDictionary];
    });
}

- (void)safe_removeAllObjects
{
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self removeAllObjects];
    });
}

- (void)safe_removeObjectsForKeys:(NSArray<NSString *> *)keyArray
{
    if (!keyArray || ![keyArray isKindOfClass:[NSArray class]]) {
        return;
    }
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self removeObjectForKey:keyArray];
    });
}

- (void)safe_setDictionary:(NSDictionary<NSString *, id> *)otherDictionary
{
    if (!otherDictionary || ![otherDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    ln_safe_op_dic_write(self.operationQueue, ^{
        [self setDictionary:otherDictionary];
    });
}
//

//static dispatch_semaphore_t ln_lock_semaphore = nil;
//
//static inline void ln_safe_op_dic_write(dispatch_semaphore_t semaphore, void (^block)(void)){
//
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    block();
//    dispatch_semaphore_signal(semaphore);
//}
//
//static inline id ln_safe_op_dic_read(dispatch_semaphore_t semaphore, id (^block)(void)){
//    __block id data = nil;
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//     data = block();
//    dispatch_semaphore_signal(semaphore);
//    return data;
//}
//
//@interface NSMutableDictionary ()
//
//@property (nonatomic, strong) dispatch_queue_t operationQueue;
//
//@end
//
//@implementation NSMutableDictionary (SafeOp)
//
//- (dispatch_semaphore_t)semaphore
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ln_lock_semaphore = dispatch_semaphore_create(1);
//    });
//    return ln_lock_semaphore;
//}
//
//- (NSInteger)safe_count
//{
//    NSNumber *countNum = ln_safe_op_dic_read(self.semaphore, ^id{
//        NSInteger count = self.count;
//        return @(count);
//    });
//    return [countNum integerValue];
//}
//
//- (id)safe_objectForKey:(NSString *)key
//{
//    if (!key) {
//        return nil;
//    }
//    id object = ln_safe_op_dic_read(self.semaphore, ^id{
//        return [self objectForKey:key];
//    });
//    return object;
//}
//
//- (NSArray <NSString *>*)safe_allKeys
//{
//    NSArray *keys = ln_safe_op_dic_read(self.semaphore, ^id{
//        return [self allKeys];
//    });
//    return keys;
//}
//
//- (NSArray<NSString *> *)safe_allKeysForObject:(id)anObject
//{
//    if (!anObject) {
//        return nil;
//    }
//    NSArray *keys = ln_safe_op_dic_read(self.semaphore, ^id{
//        return [self allKeysForObject:anObject];
//    });
//    return keys;
//}
//
//- (NSArray <NSString *>*)safe_allValues
//{
//    NSArray *keys = ln_safe_op_dic_read(self.semaphore, ^id{
//        return [self allValues];
//    });
//    return keys;
//}
//
//- (NSString *)description
//{
//    NSString *description = ln_safe_op_dic_read(self.semaphore, ^id{
//        return [self description];
//    });
//    return description;
//}
//
//
//- (void)safe_removeObjectForKey:(NSString *)key
//{
//    if (!key) {
//        return;
//    }
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self removeObjectForKey:key];
//    });
//}
//
//- (void)safe_setObject:(id)object forKey:(NSString *)key
//{
//    if (!object || !key) {
//        return;
//    }
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self setObject:object forKey:key];
//    });
//}
//
//- (void)safe_addEntriesFromDictionary:(NSDictionary<NSString *, id> *)otherDictionary
//{
//    if (!otherDictionary || ![otherDictionary isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self addEntriesFromDictionary:otherDictionary];
//    });
//}
//
//- (void)safe_removeAllObjects
//{
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self removeAllObjects];
//    });
//}
//
//- (void)safe_removeObjectsForKeys:(NSArray<NSString *> *)keyArray
//{
//    if (!keyArray || ![keyArray isKindOfClass:[NSArray class]]) {
//        return;
//    }
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self removeObjectForKey:keyArray];
//    });
//}
//
//- (void)safe_setDictionary:(NSDictionary<NSString *, id> *)otherDictionary
//{
//    if (!otherDictionary || ![otherDictionary isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    ln_safe_op_dic_write(self.semaphore, ^{
//        [self setDictionary:otherDictionary];
//    });
//}
//


@end
