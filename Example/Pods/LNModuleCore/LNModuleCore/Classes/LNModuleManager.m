//
//  LNModuleManager.m
//  LNCore
//
//  Created by Lenny on 2020/6/30.
//

#import "LNModuleManager.h"
#import "LNModuleBaseProtocol.h"
@interface LNModuleManager ()

@property(nonatomic, strong) NSMutableDictionary *modulNames;

@property(nonatomic, strong) NSMutableDictionary *allImpInstanceInfos;

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
        _modulNames = [[NSMutableDictionary alloc] init];
        _allImpInstanceInfos = [[NSMutableDictionary alloc] init];
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)addImpClassName:(NSString *)impClassName
           protocolName:(NSString *)protocolName
{
    if (impClassName && protocolName) {
        [self.modulNames setObject:impClassName forKey:protocolName];
    }
}

- (id)createImpInstanceWithClass:(Class)impClass
                        protocol:(Protocol *)protocol
{
    if (!impClass) {
        NSLog(@"ImpClass is nill");
        return nil;
    }
    if (!protocol) {
        NSLog(@"Protocol is nil");
        return nil;
    }
    if (![impClass conformsToProtocol:protocol]) {
        NSLog(@"Class %@ do not conforms to protocol:%@", impClass, protocol);
        return nil;
    }
    id imp = nil;
    if ([impClass respondsToSelector:@selector(sharedInstance)]) {
       imp = [impClass sharedInstance];
    }else{
        imp = [[impClass alloc] init];
    }
    if (![imp conformsToProtocol:protocol]) {
        NSLog(@"Instance %@ do not conforms to protocol:%@", imp, protocol);
        return nil;
    }else{
        if ([imp respondsToSelector:@selector(doInitialize)]) {
            [imp doInitialize];
        }
    }
    return imp;
}

- (void)addImpInstance:(id)impInstacne
          protocolName:(NSString *)protocolName
{
    if (!impInstacne) {
        NSLog(@"Invalid impInstacne:%@", impInstacne);
        return;
    }
    if (!protocolName) {
        NSLog(@"Invalid protocolName:%@", protocolName);
        return;
    }
    [_lock lock];
    [_allImpInstanceInfos setObject:impInstacne forKey:protocolName];
    [_lock unlock];
}

- (id)impInstanceForProtocol:(Protocol *)protocol
{
    if (!protocol) {
        NSLog(@"Protocol is nil");
        return nil;
    }
    NSString *protocolName = NSStringFromProtocol(protocol);
    id impInstance = nil;
    [_lock lock];
    impInstance = [_allImpInstanceInfos objectForKey:protocolName];
    [_lock unlock];
    if (impInstance) {
        return impInstance;
    }
    NSString *className = [self.modulNames objectForKey:protocolName];
    if (!className) {
        NSLog(@"No valid implementation class name for protocol:%@",protocolName);
        return nil;
    }
    Class impCls = NSClassFromString(className);
    impInstance = [self createImpInstanceWithClass:impCls protocol:protocol];
    [self addImpInstance:impInstance protocolName:protocolName];
    return impInstance;
}


- (id)impInstanceForProtocolName:(NSString *)protocolName
{
    if (!protocolName) {
        NSLog(@"protocolName is nil");
        return nil;
    }
    Protocol *protocol = NSProtocolFromString(protocolName);
    if (!protocol) {
        NSLog(@"No valid Protocol name %@", protocolName);
        return nil;
    }
    return [self impInstanceForProtocol:protocol];
}

- (void)removeInstanceForProtocol:(Protocol *)protocol
{
    if (!protocol) {
        return;
    }
    NSString *protocolName = NSStringFromProtocol(protocol);
    [_lock lock];
    [_allImpInstanceInfos removeObjectForKey:protocolName];
    [_lock unlock];
    
}

- (NSDictionary *)allImpInstanceInfos;
{
    NSDictionary *dict = nil;
    [_lock lock];
    dict = [_allImpInstanceInfos copy];
    [_lock unlock];
    return dict;
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

@end
