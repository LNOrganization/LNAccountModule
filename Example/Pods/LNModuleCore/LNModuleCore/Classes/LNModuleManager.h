
//  LNModuleManager.h
//  LNCore
//
//  Created by Lenny on 2020/6/30.
//

#import <Foundation/Foundation.h>
#import "LNModuleAppDelegate.h"
#import "LNModuleBaseProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface LNModuleManager : NSObject

+(LNModuleManager *)sharedInstance;

- (void)addImpClassName:(NSString *)impClassName
           protocolName:(NSString *)protocolName;

- (id<LNModuleBaseProtocol>)impInstanceForProtocol:(Protocol *)protocol;

- (NSDictionary *)allImpInstanceInfos;

- (void)creatImpInstancesWithProtocols:(NSArray<Protocol *> *)protocols;

- (NSDictionary *)creatImpInstancesDidFinishLaunching;

@end


NS_ASSUME_NONNULL_END
