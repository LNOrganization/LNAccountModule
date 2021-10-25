//
//  LNLoginViewController.h
//  LNAccountModule
//
//  Created by Lenny on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "LNAccountModuleConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface LNLoginViewController : UIViewController

@property(nonatomic, copy) LNAccountLoginCompletion loginCompletion;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeField;

- (IBAction)shenCheckCode:(UIButton *)sender;

- (IBAction)clickOnLogin:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
