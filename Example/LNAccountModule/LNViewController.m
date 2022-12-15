//
//  LNViewController.m
//  LNAccountModule
//
//  Created by dongjianxiong on 10/22/2021.
//  Copyright (c) 2021 dongjianxiong. All rights reserved.
//

#import "LNViewController.h"
#import <LNModuleCore/LNModuleCore.h>
#import <LNModuleProtocol/LNAccountModuleProtocol.h>
#import "LNTestManager.h"
#import "LNSecondViewController.h"

@interface LNViewController ()

@end

@implementation LNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        NSLog(@"3");
    } observer:self];
    
    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        NSLog(@"4");
    } observer:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    id<LNAccountModuleProtocol> loginModule = (id)[[LNModuleManager sharedInstance] impInstanceForProtocol:@protocol(LNAccountModuleProtocol)];
//    [loginModule loginIfNeed:^(NSDictionary *accountInfo, NSString *errMsg) {
//        if (accountInfo) {
//            NSLog(@"登录成功:%@", accountInfo);
//        }else{
//            NSLog(@"登录失败:%@", errMsg);
//        }
//        [loginModule logout];
//    }];
    
//   id obj1 = [[NSObject alloc] init];
//    [[LNTestManager shareInstance].hashTable addObject:obj1];
//    [self print:1];
    
//    [[LNTestManager shareInstance].hashTable addObject:[[NSObject alloc] init]];
//    [self print:2];
    
    LNSecondViewController *vc = [[LNSecondViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[LNTestManager shareInstance].hashTable addObject:vc];
//    [self print:3];
        
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self print:4];
    [self performSelector:@selector(print:) withObject:nil afterDelay:5];
}

- (void)print:(NSInteger)index
{
//    NSLog(@"-----count:%@------<><%@><>-----", @([LNTestManager shareInstance].hashTable.allObjects.count), @(index));
//    NSLog(@"=====start:%@<%@><%@><>=====", @(index), @(index), @(index));
//    NSInteger i = 1;
//    for (id object in [LNTestManager shareInstance].hashTable.allObjects) {
//        NSLog(@"-----object:%@<><%@><>-----", object, @(i));
//        i++;
//    }
//    NSLog(@"++++++end:%@<%@><%@><>+++++", @(index), @(index), @(index));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
