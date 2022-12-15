//
//  UIScreen+LNUIKit.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/2.
//

#import "UIScreen+LNUIKit.h"

@implementation UIScreen (LNUIKit)

+(CGFloat)width
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat)height
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(CGSize)size
{
    return [UIScreen mainScreen].bounds.size;
}

@end
