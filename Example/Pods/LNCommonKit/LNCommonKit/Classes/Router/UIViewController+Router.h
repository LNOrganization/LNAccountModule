//
//  UIViewController+Router.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (Router)

- (UIViewController *)topViewController:(UIViewController *)vc;

- (UIViewController *)currentViewController;

- (void)pushToViewControll:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
