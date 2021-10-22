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

- (id<LNModuleBaseProtocol>)createImpInstanceWithClassName:(NSString *)impClassname
                                          protocolName:(NSString *)protocolName
{
    if (!impClassname) {
        NSLog(@"Invalid impClassname:%@", impClassname);
        return nil;
    }
    if (!protocolName) {
        NSLog(@"Invalid protocolName:%@", protocolName);
        return nil;
    }
    Class impClass = NSClassFromString(impClassname);
    if (impClass) {
        id imp = [[impClass alloc] init];
        if ([imp conformsToProtocol:NSProtocolFromString(protocolName)]) {
            return imp;
        }
    }else{
        NSLog(@"No valid implementation class for protocol:%@",protocolName);
    }
    return nil;
}

- (void)addImpInstance:(id<LNModuleBaseProtocol>)impInstacne
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

- (id<LNModuleBaseProtocol>)impInstanceForProtocol:(Protocol *)protocol
{
    if (!protocol) {
        return nil;
    }
    NSString *protocolName = NSStringFromProtocol(protocol);
    return [self impInstanceForProtocolName:protocolName];
}

- (id<LNModuleBaseProtocol>)impInstanceForProtocolName:(NSString *)protocolName
{
    
    id<LNModuleBaseProtocol> impInstance = [_allImpInstanceInfos objectForKey:protocolName];;
    if (impInstance) {
        return impInstance;
    }
    NSString *className = [self.modulNames objectForKey:protocolName];
    if (className) {
        impInstance = [self createImpInstanceWithClassName:className protocolName:protocolName];
        [self addImpInstance:impInstance protocolName:protocolName];
    }else{
        NSLog(@"No valid implementation class name for protocol:%@",protocolName);
    }
    return impInstance;
}

- (NSDictionary *)allImpInstanceInfos;
{
    NSDictionary *dict = nil;
    if (!_allImpInstanceInfos) {
        [_lock lock];
        _allImpInstanceInfos = [[NSMutableDictionary alloc] init];
        if (_modulNames) {
            [_modulNames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *impClassname = obj;
                id<LNModuleBaseProtocol> modul = [self createImpInstanceWithClassName:impClassname protocolName:key];
                [self addImpInstance:modul protocolName:key];
            }];
        }
        dict = [_allImpInstanceInfos copy];
        
    }else{
        [_lock lock];
        dict = [_allImpInstanceInfos copy];
        [_lock unlock];
    }
    return dict;
}

- (void)creatImpInstancesWithProtocols:(NSArray<Protocol *> *)protocols
{
    for (Protocol *protocol in protocols) {
        NSString *protocolName = NSStringFromProtocol(protocol);
       [self impInstanceForProtocolName:protocolName];
    }
}

- (NSDictionary *)creatImpInstancesDidFinishLaunching
{
    return [self allImpInstanceInfos];
}


@end
