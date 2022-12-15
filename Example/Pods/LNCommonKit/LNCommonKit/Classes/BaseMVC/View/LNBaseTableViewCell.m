//
//  LNBaseTableViewCell.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/9/3.
//

#import "LNBaseTableViewCell.h"

@implementation LNBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
