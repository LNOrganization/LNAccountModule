//
//  UIViewController+Router.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (Router)

- (UIViewController *)ln_topViewController:(UIViewController *)vc;

- (UIViewController *)ln_currentViewController;

- (void)ln_pushViewController:(UIViewController *)viewController;

- (void)ln_pushViewController:(UIViewController *)viewController
                     animated: (BOOL)animated;

- (void)ln_presentViewController:(UIViewController *)viewController;

- (void)ln_presentViewController:(UIViewController *)viewController
                         animated: (BOOL)animated
                       completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
