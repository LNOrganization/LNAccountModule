//
//  LNImageLoopScrollView.m
//  LNImageLoopScrollView
//
//  Created by dongjianxiong on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//


#import "LNImageLoopScrollView.h"

typedef NS_ENUM(NSInteger, LNImageScrollDirection) {
    LNImageScrollDirectionLeft,
    LNImageScrollDirectionRight,
};

@interface LNImageLoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 * 子视图数组
 */
@property (nonatomic, strong) NSMutableArray *containerViews;

/**
 * 图片视图数组
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 * 显示分页标记
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) LNImageScrollDirection direction;

@property (nonatomic, assign) NSTimeInterval timerInterval;

@property (nonatomic, assign) BOOL isTimer;

@end

@implementation LNImageLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];

        self.containerViews = [NSMutableArray array];
        self.imageViews = [NSMutableArray array];

    }
    return self;
}

- (void)dealloc
{
    [self cancelTimer];
}

- (void)setTotalCount:(NSUInteger)totalCount
{
    _totalCount = totalCount;
    if (totalCount > 1) {
        [self creatImageViewsWithCount:3];
    }else{
        [self creatImageViewsWithCount:1];
    }
    self.pageControl.numberOfPages = totalCount;
    [self reloadImages];
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)creatImageViewsWithCount:(NSUInteger)count
{
    if (self.containerViews.count != count) {
        for (UIView *view in self.containerViews) {
            [view removeFromSuperview];
        }
        for (UIImageView *imageView in self.imageViews) {
            [imageView removeFromSuperview];
        }
        [self.containerViews removeAllObjects];
        [self.imageViews removeAllObjects];
        for (int index = 0; index < count; index ++) {//创建三个imageView用于循环显示图片
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((index) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [self.scrollView addSubview:containerView];
            [self.containerViews addObject:containerView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            [containerView addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
    }
}

- (void)reloadImages
{
    if (self.totalCount == 0) {
        return;
    }
    if (self.totalCount == 1) {//当只有一张图片的时候不滚动
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.scrollEnabled = NO;
    }else{
        //当图片数大于一张时可以滚动
        self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.scrollView.scrollEnabled = YES;
    }
    [self resetImageViews];
}

- (void)timerSart:(NSTimeInterval)interval
{
    self.direction = LNImageScrollDirectionRight;
    if (interval <= 0) {
        interval = 3;
    }
    self.isTimer = YES;
    self.timerInterval = interval;
    
    [self starTimer];
}


- (void)hiddenPage:(BOOL)isHidden;
{
    self.pageControl.hidden = isHidden;
}


- (void)setPageControllCenter:(CGPoint)center
{
    self.pageControl.center = center;
}

- (void)starTimer
{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), (uint64_t)(self.timerInterval*NSEC_PER_SEC), 0);

    dispatch_source_set_event_handler(self.timer, ^{
        if (self.timer == nil) {
            return;
        }
        if (self.direction == LNImageScrollDirectionRight) {
            if (self.totalCount > 1) {
                [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0.0f) animated:true];
            }else{
                [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            }
        }else if (self.direction == LNImageScrollDirectionLeft) {
            [self.scrollView setContentOffset:CGPointMake(0, 0.0f) animated:true];
        }else{
//           [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * self.imageViews.count/2, 0.0f) animated:true];
        }
    });
    dispatch_resume(self.timer);
}

- (void)cancelTimer
{
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

//当视图滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (CGRectGetWidth(scrollView.frame) * 2)) {
        self.direction = LNImageScrollDirectionRight;;
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
        [self resetImageViews];
    }else if(scrollView.contentOffset.x <=0) {
        self.direction = LNImageScrollDirectionLeft;
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
        [self resetImageViews];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelTimer];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isTimer) {
//        [self starTimer];
        [self performSelector:@selector(starTimer) withObject:nil afterDelay:5];
    }
//    [self performSelector:@selector(starTimer) withObject:nil afterDelay:5];
}

//
- (void)resetImageViews
{
    if (self.totalCount == 1) {
        //如果只有一张图片，不需要滚动
        NSInteger leftPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex];
        [self imageAtIndex:leftPage location:0];
        [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    }else if (self.totalCount > 1){
        
        //设置将要在左边显示的视图
        NSInteger leftPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
        [self imageAtIndex:leftPage location:0];

         //设置将要显示的视图
        NSInteger currentPage = self.currentPageIndex;
        [self imageAtIndex:currentPage location:1];

        //获取将要在右边显示的视图
        NSInteger rightPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
        [self imageAtIndex:rightPage location:2];

        //视图布局完之后返回到中间的位置
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0f) animated:NO];

    }else{
        NSLog(@"There is no subviews to show");
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.circleDelegate) {
        [self.circleDelegate circleScrollView:self didSelectedAtIndex:self.currentPageIndex];
    }
}


- (void)imageAtIndex:(NSInteger)index
          location:(NSInteger)location
{

    UIEdgeInsets edgeInsets = [self.circleDelegate circleScrollViewImageEdgeInset:self atIndex:index];
    //重新对子视图进行布局
    UIImageView *imageView = self.imageViews[location];
    CGFloat imageWidth = self.frame.size.width - edgeInsets.left - edgeInsets.right;
    CGFloat imageHeight = self.frame.size.height - edgeInsets.top - edgeInsets.bottom;
    imageView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, imageWidth, imageHeight);
    [self.circleDelegate circleScrollView:self imageView:imageView atIndex:index];
}

//获取有效下一页
- (NSInteger)validNextPageWithExpectedNextPage:(NSInteger)expectedNextPage
{
    NSInteger totalCount = self.totalCount;
    if (expectedNextPage == -1) {
        return totalCount - 1;
    }else if (expectedNextPage == totalCount || expectedNextPage < -1){
        return 0;
    }else if (expectedNextPage > totalCount){
        return totalCount - 1;
    }else{
        return expectedNextPage;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
