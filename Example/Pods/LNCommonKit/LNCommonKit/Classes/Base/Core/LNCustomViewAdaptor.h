//
//  LNCustomViewAdaptor.h
//  LNFeedModule
//
//  Created by Lenny on 2022/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNCustomViewAdaptor <NSObject>

/** 子类型重写，实现子视图创建和添加 */
- (void)addSubviews;

/** 子类型重写，更新视图展示的内容 */
- (void)reloadWithData:(id)data;

/** 子类型重写，更新视图的布局 */
- (void)updateSubviewsLayout;

/** 子类型重写，更新视图的样式 */
- (void)updateSubviewsStyle;

/** 子类型重写，视图reuseIdentifier */
+ (NSString *)reuseIdentifier;


@end

NS_ASSUME_NONNULL_END
