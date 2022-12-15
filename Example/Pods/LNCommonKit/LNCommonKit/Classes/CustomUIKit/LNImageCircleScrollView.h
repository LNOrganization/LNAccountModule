//
//  DJXScrollView.h
//  DJXScrollView
//
//  Created by dongjianxiong on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@class LNImageCircleScrollView;
//
//@protocol LNImageCircleScrollViewDelegate <NSObject>
//
//- (NSInteger)numberOfImage:(LNImageCircleScrollView *)scrollView;
//- (void)circleScrollView:(LNImageCircleScrollView *)scrollView imageView:(UIImageView *)imageView atIndex:(NSInteger)index;
//- (UIEdgeInsets)circleScrollViewImageInset:(LNImageCircleScrollView *)scrollView;
//- (void)circleScrollView:(LNImageCircleScrollView *)scrollView didSelectedAtIndex:(NSInteger)index;
//
//@end
//
//@interface LNImageCircleScrollView : UIScrollView
//
//@property (nonatomic, weak) id<LNImageCircleScrollViewDelegate> circleDelegate;
//
////重载图片
//- (void)reloadImages;
//
////开启定时器滚动，默认不开启
//- (void)timerSart:(NSTimeInterval)interval;
//
////是否显示分页，默认显示
//- (void)hiddenPage:(BOOL)isHidden;
//
//@end


#import <UIKit/UIKit.h>

@class LNImageCircleScrollView;

@protocol LNImageCircleScrollViewDelegate <NSObject>
/**
设置图片
 @param scrollImageView  当前视图
 @param imageView  显示图片的UIImageView
 @param index  图片位置
 */
- (void)circleScrollView:(LNImageCircleScrollView *_Nullable)scrollImageView imageView:(UIImageView *_Nullable)imageView atIndex:(NSUInteger)index;

/**
设置图片边距
@param scrollImageView  当前视图
@param index  图片位置
*/
- (UIEdgeInsets)circleScrollViewImageEdgeInset:(LNImageCircleScrollView *_Nullable)scrollImageView atIndex:(NSUInteger)index;

/**
点击图片
@param scrollImageView  当前视图
@param index  图片位置
*/
- (void)circleScrollView:(LNImageCircleScrollView *_Nullable)scrollImageView didSelectedAtIndex:(NSInteger)index;

@end

@interface LNImageCircleScrollView : UIScrollView

//接收回调的代理
@property (nonatomic, weak) id<LNImageCircleScrollViewDelegate> _Nullable circleDelegate;
///显示图片的个数
@property (nonatomic, assign) NSUInteger totalCount;

//重载图片
- (void)reloadImages;

//开启定时器滚动，默认不开启
- (void)timerSart:(NSTimeInterval)interval;

//是否显示分页，默认显示
- (void)hiddenPage:(BOOL)isHidden;

@end

