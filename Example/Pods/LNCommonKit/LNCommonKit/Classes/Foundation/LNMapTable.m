//
//  LNMapTable.m
//  LNCommonKit
//
//  Created by Lenny on 2021/12/4.
//

#import "LNMapTable.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_mapTable) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);


@interface LNMapTable ()

@property(nonatomic, strong) NSMapTable *mapTable;

@property(nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation LNMapTable

- (instancetype)init
{
    INIT(_mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];)
}

- (instancetype)initWithKeyOptions:(NSPointerFunctionsOptions)keyOptions valueOptions:(NSPointerFunctionsOptions)valueOptions capacity:(NSUInteger)initialCapacity
{
    INIT(_mapTable = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:valueOptions capacity:initialCapacity];)
}

- (nullable LNObjectType)objectForKey:(nullable LNKeyType)aKey
{
    LOCK(LNObjectType object = [_mapTable objectForKey:aKey]); return object;
}

- (void)removeObjectForKey:(nullable LNKeyType)aKey
{
    if (aKey) {
        LOCK([_mapTable removeObjectForKey:aKey]);
    }
}

- (void)setObject:(nullable LNObjectType)anObject forKey:(nullable LNKeyType)aKey
{
    if (anObject && aKey) {
        LOCK([_mapTable setObject:anObject forKey:aKey]);
    }
}

- (NSUInteger)count
{
    LOCK(NSUInteger count = _mapTable.count); return count;
}


- (NSEnumerator<LNKeyType> *)keyEnumerator
{
    LOCK(NSEnumerator<LNKeyType> * ret = [_mapTable keyEnumerator]); return ret;
}

- (nullable NSEnumerator<LNObjectType> *)objectEnumerator
{
    LOCK(NSEnumerator<LNObjectType> * ret = [_mapTable objectEnumerator]); return ret;
}

- (void)removeAllObjects
{
    LOCK([_mapTable removeAllObjects]);
}

- (NSDictionary<LNKeyType, LNObjectType> *)dictionaryRepresentation
{
    LOCK(NSDictionary<LNKeyType, LNObjectType> * ret = [_mapTable dictionaryRepresentation]); return ret;
}



@end


