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

@interface LNViewController ()


@end

@implementation LNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    id<LNAccountModuleProtocol> loginModule = (id)[[LNModuleManager sharedInstance] impInstanceForProtocol:@protocol(LNAccountModuleProtocol)];
    [loginModule loginIfNeed:^(NSDictionary *accountInfo, NSString *errMsg) {
        if (accountInfo) {
            NSLog(@"登录成功:%@", accountInfo);
        }else{
            NSLog(@"登录失败:%@", errMsg);
        }
        [loginModule logout];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
