//
//  LNBaseTableViewController.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import "LNBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LNCustomUIKit.h"

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
        _indicatorView.center = CGPointMake(LNUIScreenWidth/2, LNUIScreenHeight/2);
        _indicatorView.color = [UIColor grayColor];
    }
    return _indicatorView;
}

- (NSArray *)dataArray
{
    return _provider.dataList;
}

- (void)setProvider:(id<LNChildListDataAdaptor>)provider
{
    _provider = provider;
    _provider.delegate = self;
}

#pragma mark - UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


#pragma mark -  LNListDataProviderDelegate
- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType
{
//    self.loadingTime = CFAbsoluteTimeGetCurrent();
    [self.indicatorView startAnimating];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
         loadSucceed:(NSArray *)data
         requestType:(LNListDataLoadType)requestType
{
    if (!data || data.count == 0) {
        if (requestType != LNListDataLoadTypeLoadMore) {
            NSLog(@"暂无数据");
        }else{
            NSLog(@"暂时没有更多数据了");
        }
    }
    [self endLoading:requestType];
    [self.tableView reloadData];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
          loadFailed:(NSString *)errMsg
         requestType:(LNListDataLoadType)requestType
{
    NSLog(@"error:%@", errMsg);
    [self endLoading:requestType];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
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

#pragma mark - public
- (void)reloadTableViewCell:(UITableViewCell *)cell
{
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


@end
