//
//  LNTableViewDataSource.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNTableViewDataSource <UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIView *errorView;

- (void)reloadCell:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
