//
//  LNBaseTableViewController.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import "LNBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LNCustomUIKit.h"
#import "LNBaseTableViewCell.h"

@interface LNBaseTableViewController ()

//@property(nonatomic, assign) CFAbsoluteTime loadingTime;

@end

@implementation LNBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicatorView];
    // Do any additional setup after loading the view.
}

#pragma mark - setters and getters
- (void)setProvider:(id<LNListDataAdaptor>)provider
{
    _provider = provider;
    _provider.delegate = self;
}

#pragma mark - LNTableViewDataSource
@synthesize dataArray = _dataArray;

@synthesize indicatorView = _indicatorView;

@synthesize tableView = _tableView;

@synthesize errorView = _errorView;

- (NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [self.provider dataListInSection:0];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.provider refreshData];
         }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.provider loadMoreData];
        }];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _indicatorView.center = CGPointMake(LNScreenWidth/2, LNScreenHeight/2);
        _indicatorView.color = [UIColor grayColor];
    }
    return _indicatorView;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LNScreenWidth, LNScreenHeight)];
        _errorView.hidden = YES;
    }
    return _errorView;
}


- (void)reloadCell:(nonnull UITableViewCell *)cell {
    if (!cell) {
        [self.tableView reloadData];
        return;
    }
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.tableView reloadData];
    }
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.provider numberOfSections];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfObjectsInSection:section];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *cellID = @"CellID";
    LNBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LNBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    id object = [self.provider objectAtIndexPath:indexPath];
    [cell reloadWithData:object];
    return cell;
}

#pragma mark -  LNListDataProviderDelegate
- (void)dataProvider:(id<LNListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType
{
//    self.loadingTime = CFAbsoluteTimeGetCurrent();
    [self.indicatorView startAnimating];
}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
            loadType:(LNListDataLoadType)loadType
          loadStatus:(LNListDataLoadStatus)loadStatus
             message:(NSString *)message
{
    if (loadStatus == LNListDataLoadStatusEmpty) {
        if (loadType != LNListDataLoadTypeLoadMore) {
            NSLog(@"暂无数据");
        }else{
            NSLog(@"暂时没有更多数据了");
        }
    }
    NSLog(@"message:%@", message);
    [self endLoading:loadType];
    [self.tableView reloadData];
}


- (void)dataProvider:(id<LNListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      insertedAtIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)endLoading:(LNListDataLoadType)requestType
{
    if (requestType == LNListDataLoadTypeLoadMore) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    [self.indicatorView stopAnimating];
}

@end
