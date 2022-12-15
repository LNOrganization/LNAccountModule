//
//  NSObject+LNKVO.h
//  KVO
//
//  Created by Lenny on 2019/1/5.
//  Copyright © 2019 Lenny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LNKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

@interface NSObject (LNKVO)

- (void)ln_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(LNKVOBlock)block;

- (void)ln_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
