//
//  UIViewController+Mediator.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import "UIViewController+Router.h"
#import "LNRouter.h"

@implementation UIViewController (Router)

- (UIViewController *)ln_topViewController:(UIViewController *)vc {
    return [LNRouter topViewController:vc];
}

- (UIViewController *)ln_currentViewController {
    UIViewController *vc = [self ln_topViewController:self];
    return vc;
}

- (void)ln_pushViewController:(UIViewController *)viewController
{
    [self ln_pushViewController:viewController animated:YES];
}

- (void)ln_pushViewController:(UIViewController *)viewController
                     animated: (BOOL)animated
{
    [LNRouter pushViewController:viewController animated:animated];
}

- (void)ln_presentViewController:(UIViewController *)viewController
{
    [self ln_presentViewController:viewController animated:YES completion:nil];
}

- (void)ln_presentViewController:(UIViewController *)viewController
                         animated: (BOOL)animated
                       completion:(void (^ __nullable)(void))completion
{
    [LNRouter presentFromViewController:self toViewController:viewController animated:animated completion:completion];
}
@end
