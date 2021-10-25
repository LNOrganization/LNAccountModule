//
//  LNModuleProtocol.h
//  LNCore
//
//  Created by Lenny on 2021/10/12.
//

#import <UIKit/UIKit.h>

@protocol LNModuleBaseProtocol <UIApplicationDelegate>

- (NSString *)version;

- (void)doInitialize;


@end
