//
//  LNRouter.h
//  LNCommonKit
//
//  Created by Lenny on 2021/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNRouter : NSObject


+ (UIViewController *)topViewController:(UIViewController *)vc;

+ (UIViewController *)currentViewController;

+ (void)pushViewController:(UIViewController *)viewController;

+ (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

+ (void)presentFromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController;

+ (void)presentFromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController
                         animated: (BOOL)animated
                       completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
