//
//  LNCustomUIKit.h
//  Pods
//
//  Created by Lenny on 2022/12/6.
//

#ifndef LNCustomUIKit_h
#define LNCustomUIKit_h

#import "LNImageCircleScrollView.h"
#import "UIColor+Custom.h"
#import "UIScreen+LNUIKit.h"


#define LNScreenWidth               [UIScreen mainScreen].bounds.size.width
#define LNScreenHeight              [UIScreen mainScreen].bounds.size.height
#define LNMaxScreenWidth            MAX(LGScreenWidth, LNScreenHeight)
#define LNMinScreenHeight           MIN(LGScreenWidth, LNScreenHeight)
#define LNIsiPhoneX                 (LNMaxScreenWidth >= 812 ? YES : NO)
#define LNNavigationBarHeight       (LNIsiPhoneX ? 88 : 64)
#define LNTabbarHeight              (LNIsiPhoneX ? 83 : 49)
#define LNStatusBarHeight           (LNIsiPhoneX ? 44 : 20)
#define LNBottomBarHeight           (LNIsiPhoneX ? 20 : 0)

#endif /* LNCustomUIKit_h */
