//
//  LNRouter.m
//  LNCommonKit
//
//  Created by Lenny on 2021/10/25.
//

#import "LNRouter.h"

@implementation LNRouter

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
    UIViewController *vc = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    return vc;
}

- (void)pushToViewControll:(UIViewController *)viewController
{
    UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (currentViewController.navigationController) {
        [currentViewController.navigationController pushViewController:viewController animated:YES];
    }else{
        [currentViewController presentViewController:viewController animated:YES completion:nil];
    }
}


@end
