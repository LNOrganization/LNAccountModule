//
//  LNTestManager.h
//  LNAccountModule_Example
//
//  Created by Lenny on 2022/12/5.
//  Copyright © 2022 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LNCommonKit/LNCommonKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LNTestBlock)(BOOL isLogin, id object);

@interface LNTestManager : NSObject

+ (LNTestManager *)shareInstance;

@property(nonatomic, strong) LNHashTable *hashTable;

@property(nonatomic, strong) LNMapTable *weakMapTable;

+ (void)registerLoginCompletionNotify:(LNTestBlock)completion;

+ (void)registerLoginNotify:(LNTestBlock)completion
                   observer:(id)observer;


@end

NS_ASSUME_NONNULL_END
