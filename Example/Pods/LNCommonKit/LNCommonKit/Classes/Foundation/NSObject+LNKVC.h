//
//  NSObject+LNKVC.h
//  KVC
//
//  Created by Lenny on 2019/12/9.
//  Copyright © 2019 Lenny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LNKVC)

// 自定义KVO接口
- (void)ln_setValue:(nullable id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
