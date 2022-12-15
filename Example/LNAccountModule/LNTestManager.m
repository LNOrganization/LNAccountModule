//
//  LNTestManager.m
//  LNAccountModule_Example
//
//  Created by Lenny on 2022/12/5.
//  Copyright © 2022 dongjianxiong. All rights reserved.
//

#import "LNTestManager.h"

@interface LNTestManager ()

@property(nonatomic, strong) LNGCDTimer *timer;

@end

@implementation LNTestManager

+ (LNTestManager *)shareInstance
{
    static LNTestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNTestManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hashTable = [[LNHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
        _weakMapTable = [[LNMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                  valueOptions:NSPointerFunctionsCopyIn capacity:0];
        _timer = [LNGCDTimer timerWithTimeInterval:5 target:self selector:@selector(print) repeats:YES];
        [_timer fire];
    }
    return self;
}

+ (void)registerLoginCompletionNotify:(LNTestBlock)completion
{
    if (completion) {
        [[[self class] shareInstance].hashTable addObject:completion];
        
    }
}

+ (void)registerLoginNotify:(LNTestBlock)completion
                   observer:(id)observer
{
    if (observer) {
        [[[self class] shareInstance].weakMapTable setObject:observer forKey:completion];
    }
}

- (void)print
{
    NSLog(@"--current count:%@", @(self.weakMapTable.count));

    NSArray *keys = [self.weakMapTable.keyEnumerator allObjects];
    NSLog(@"========keys.count:%@", @(keys.count));
    for (id key in keys) {
        LNTestBlock block = [self.weakMapTable objectForKey:key];
        block(YES, key);
    }
    NSLog(@"--------------------------------------");
    NSArray *objs = [self.weakMapTable.objectEnumerator allObjects];
    NSLog(@"+++++++++objs.count:%@", @(keys.count));
    for (LNTestBlock block in objs) {
        block(YES, block);
    }
    
}



@end
