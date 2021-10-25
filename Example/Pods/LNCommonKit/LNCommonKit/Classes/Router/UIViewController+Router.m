//
//  UIViewController+Mediator.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import "UIViewController+Router.h"


@implementation UIViewController (Router)

- (UIViewController *)topViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self topViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController*)vc;
        if (svc.viewControllers.count > 0) {
            return [self topViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController*)vc;
        if (navC.viewControllers.count > 0) {
            return [self topViewController:navC.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabC = (UITabBarController*)vc;
        if (tabC.viewControllers.count > 0) {
            return [self topViewController:tabC.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}

- (UIViewController *)currentViewController {
    UIViewController *vc = [self topViewController:self];
    return vc;
}

- (void)pushToViewControll:(UIViewController *)viewController
{
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


@end
