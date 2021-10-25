//
//  LNLoginViewController.m
//  LNAccountModule
//
//  Created by Lenny on 2021/10/23.
//

#import "LNLoginViewController.h"

@interface LNLoginViewController ()

@end

@implementation LNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 4;
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberField resignFirstResponder];
    [self.checkCodeField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickOnLogin:(UIButton *)sender {
    
    NSDictionary *accountInfo = @{@"accountId": self.phoneNumberField.text};;
    self.loginCompletion(accountInfo, nil);
}

- (IBAction)shenCheckCode:(UIButton *)sender {
    NSLog(@"send succeed");
}


@end
