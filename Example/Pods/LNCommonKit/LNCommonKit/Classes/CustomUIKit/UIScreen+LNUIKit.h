//
//  UIScreen+LNUIKit.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define LNUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define LNUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define LNUIScreenSize [UIScreen mainScreen].bounds.size

@interface UIScreen (LNUIKit)

+(CGFloat)width;
+(CGFloat)height;
+(CGSize)size;
@end

NS_ASSUME_NONNULL_END
