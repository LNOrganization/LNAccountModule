//
//  LNHashTable.m
//  LNCommonKit
//
//  Created by Lenny on 2021/12/4.
//

#import "LNHashTable.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_hashTable) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);


@interface LNHashTable ()

@property(nonatomic, strong) NSHashTable *hashTable;

@property(nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation LNHashTable

- (instancetype)init
{
    INIT(_hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsStrongMemory capacity:0];)
}

- (instancetype)initWithOptions:(NSPointerFunctionsOptions)options
                       capacity:(NSUInteger)initialCapacity
{
    INIT(_hashTable = [[NSHashTable alloc] initWithOptions:options capacity:0];)
}

- (NSUInteger)count
{
    LOCK(NSUInteger count = _hashTable.count);return count;
}

- (NSArray<id> *)allObjects
{
    LOCK(NSArray<id> * arr = [_hashTable allObjects]); return arr;
}

- (id)anyObject
{
    LOCK(id object = [_hashTable anyObject]); return object;
}

- (nullable id)member:(nullable id)object
{
    LOCK(id ret = [_hashTable member:object]); return ret;
}

- (void)addObject:(nullable id)object
{
    if (object) {
        LOCK([_hashTable addObject:object]);
    }
}

- (void)removeObject:(nullable id)object
{
    if (object) {
        LOCK([_hashTable removeObject:object]);
    }
}

- (void)removeAllObjects
{
    LOCK([_hashTable removeAllObjects]);
}

- (BOOL)containsObject:(nullable id)anObject
{
    LOCK(BOOL ret = [_hashTable containsObject:anObject]); return ret;
}

- (NSEnumerator<id> *)objectEnumerator
{
    LOCK(NSEnumerator<id> * ret = [_hashTable objectEnumerator]); return ret;
}

@end


