//
//  LNModuleBaseProtocol.h
//  LNModuleCore
//
//  Created by Lenny on 2021/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNModuleBaseProtocol <UIApplicationDelegate>

// 获取组件版本
- (NSString *)version;

// 组件初始化
- (void)doInitialize;

@optional
// 销毁组件
- (void)deInitialize;

// 单利方法
+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
