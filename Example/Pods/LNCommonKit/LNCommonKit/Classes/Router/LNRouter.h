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

+ (void)pushToViewControll:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
