//
//  LNBaseCollectionViewCell.m
//  LNFeed
//
//  Created by Lenny on 2021/10/21.
//

#import "LNBaseCollectionViewCell.h"

@implementation LNBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
    }
    return self;
}

/** 子类型重写，实现子视图创建和添加 */
- (void)addSubviews
{
    
}

/** 子类型重写，更新视图展示的内容 */
- (void)reloadWithData:(id)data
{
    
}

/** 子类型重写，更新视图的布局 */
- (void)updateSubviewsLayout
{
    
}

/** 子类型重写，更新视图的样式 */
- (void)updateSubviewsStyle
{
    
}

+ (nonnull NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}


@end
