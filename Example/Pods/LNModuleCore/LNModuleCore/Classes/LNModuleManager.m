//
//  LNModuleManager.m
//  LNCore
//
//  Created by Lenny on 2020/6/30.
//

#import "LNModuleManager.h"
#import "LNModuleBaseProtocol.h"


#define LOCK(...) dispatch_semaphore_wait(_moduleNameLock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_moduleNameLock);

@interface LNModuleManager ()
{
    dispatch_semaphore_t _moduleNameLock;
}

/** 缓存Delegate名称和组件实现类名的映射表*/
@property(nonatomic, strong) NSMutableDictionary *moduleNames;

/** 缓存Delegate名称和组件实现对象的映射表*/
@property(nonatomic, strong) NSMutableDictionary *allImpInstanceInfos;

/** 递归锁，用于同步映射表allImpInstanceInfos读写*/
@property(nonatomic, strong) NSRecursiveLock *lock;


@end

@implementation LNModuleManager


+(LNModuleManager *)sharedInstance
{
    static LNModuleManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moduleNames = [[NSMutableDictionary alloc] init];
        _allImpInstanceInfos = [[NSMutableDictionary alloc] init];
        _lock = [[NSRecursiveLock alloc] init];
        _moduleNameLock = dispatch_semaphore_create(1);

    }
    return self;
}

- (void)addImpClassName:(NSString *)impClassName
           protocolName:(NSString *)protocolName
{
    [self _safeAddImpClassName:impClassName protocolName:protocolName];
}

- (id)impInstanceForProtocol:(Protocol *)protocol
{
    if (!protocol) {
        NSLog(@"Protocol is nil");
        return nil;
    }
    NSString *protocolName = NSStringFromProtocol(protocol);
    return [self impInstanceForProtocolName:protocolName];
}


- (id)impInstanceForProtocolName:(NSString *)protocolName
{
    if (!protocolName) {
        NSLog(@"protocolName is nil");
        return nil;
    }
    id impInstance = [self _getImpInstanceForProtocolName:protocolName];
    if (impInstance) {
        return impInstance;
    }
    
    NSString *className = [self _safeGetImpClassNameWithProtocolName:protocolName];
    if (!className) {
        NSLog(@"No valid implementation class name for protocol:%@",protocolName);
        return nil;
    }
    Class impCls = NSClassFromString(className);
    impInstance = [self _createImpInstanceWithClass:impCls protocolName:protocolName];
    return impInstance;
}

- (void)creatImpInstancesWithProtocols:(NSArray<Protocol *> *)protocols
{
    for (Protocol *protocol in protocols) {
       id instance = [self impInstanceForProtocol:protocol];
        if (!instance) {
            NSLog(@"Create instance for protocol:%@ faild",protocol);
        }else{
            NSLog(@"Create instance for protocol:%@ succeed",protocol);
        }
    }
}

- (void)removeInstanceForProtocol:(Protocol *)protocol
{
    if (!protocol) {
        return;
    }
    NSString *protocolName = NSStringFromProtocol(protocol);
    [self removeInstanceForProtocolName:protocolName];
}

- (void)removeInstanceForProtocolName:(NSString *)protocolName
{
    [self _removeInstanceForProtocolName:protocolName];
}

- (NSDictionary *)allImpInstanceInfos;
{
    NSDictionary *dict = nil;
    [_lock lock];
    dict = [_allImpInstanceInfos copy];
    [_lock unlock];
    return dict;
}

#pragma mark -private method

- (id)_createImpInstanceWithClass:(Class)impClass
                    protocolName:(NSString *)protocolName
{
    if (!impClass) {
        NSLog(@"ImpClass is nill");
        return nil;
    }
    if (!protocolName) {
        NSLog(@"protocolName is nil");
        return nil;
    }
    id imp = nil;
    if ([impClass respondsToSelector:@selector(sharedInstance)]) {
       imp = [impClass sharedInstance];
    }else{
        imp = [[impClass alloc] init];
    }
    Protocol *protocol = NSProtocolFromString(protocolName);
    if (![imp conformsToProtocol:protocol]) {
        NSLog(@"Instance %@ do not conforms to protocol:%@", imp, protocol);
        return nil;
    }else{
        if ([imp respondsToSelector:@selector(doInitialize)]) {
            [imp doInitialize];
        }
        [self _addImpInstance:imp forProtocolName:protocolName];
    }
    return imp;
}

- (void)_removeInstanceForProtocolName:(NSString *)protocolName
{
    if (!protocolName) {
        return;
    }
    [_lock lock];
    [_allImpInstanceInfos removeObjectForKey:protocolName];
    [_lock unlock];
    
}

- (id)_getImpInstanceForProtocolName:(NSString *)protocolName
{
    id impInstance = nil;
    [_lock lock];
    impInstance = [_allImpInstanceInfos objectForKey:protocolName];
    [_lock unlock];
    return impInstance;
}

- (void)_addImpInstance:(id)impInstance forProtocolName:(NSString *)protocolName
{
    if (!impInstance) {
        NSLog(@"Invalid impInstance:%@", impInstance);
        return;
    }
    if (!protocolName) {
        NSLog(@"Invalid protocolName:%@", protocolName);
        return;
    }
    [_lock lock];
    [_allImpInstanceInfos setObject:impInstance forKey:protocolName];
    [_lock unlock];
}


 - (void)_safeAddImpClassName:(NSString *)impClassName
               protocolName:(NSString *)protocolName
{
    if (impClassName && protocolName) {
        LOCK([_moduleNames setObject:impClassName forKey:protocolName];);
    }
}

- (NSString *)_safeGetImpClassNameWithProtocolName:(NSString *)protocolName
{
    LOCK(NSString * className = [_moduleNames objectForKey:protocolName];); return className;;
}

@end
