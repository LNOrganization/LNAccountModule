//
//  LNSecondViewController.m
//  LNAccountModule_Example
//
//  Created by Lenny on 2022/12/5.
//  Copyright © 2022 dongjianxiong. All rights reserved.
//

#import "LNSecondViewController.h"
#import "LNTestManager.h"
@interface LNSecondViewController ()

@end

@implementation LNSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [LNTestManager registerLoginCompletionNotify:^(BOOL isLogin, id  _Nonnull object) {
//        NSLog(@"%@", self);
//    }];
    __weak typeof(self) weakSelf = self;
    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@-5", strongSelf);
    } observer:self];
    
    [LNTestManager registerLoginNotify:^(BOOL isLogin, id  _Nonnull object) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@-6", strongSelf);
    } observer:self];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)dealloc
{
    NSLog(@"LNSecondViewController dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
