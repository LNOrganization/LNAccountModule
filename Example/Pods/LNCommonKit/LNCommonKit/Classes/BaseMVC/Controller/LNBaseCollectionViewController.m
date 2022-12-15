//
//  LNBaseCollectionViewController.m
//  FBSnapshotTestCase
//
//  Created by Lenny on 2021/10/21.
//

#import "LNBaseCollectionViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LNCustomUIKit.h"

@interface LNBaseCollectionViewController ()

@end

@implementation LNBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.indicatorView];
    // Do any additional setup after loading the view.
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [self createCollectionView];
    }
    return _collectionView;
}
- (UICollectionView *)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.provider refreshData];
     }];
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.provider loadMoreData];
    }];
    return collectionView;
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

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.provider.dataList.count;
}



#pragma mark -  LNListDataProviderDelegate
- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType
{
    [self.indicatorView startAnimating];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
         loadSucceed:(NSArray *)data
         requestType:(LNListDataLoadType)requestType
{
    [self finishLoading:requestType];
    [self.collectionView reloadData];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
          loadFailed:(NSString *)errMsg
         requestType:(LNListDataLoadType)requestType
{
    NSLog(@"error:%@, requestType:%@", errMsg, @(requestType));
    [self finishLoading:requestType];
}

- (void)finishLoading:(LNListDataLoadType)requestType
{
    if (requestType == LNListDataLoadTypeLoadMore) {
        [self.collectionView.mj_footer endRefreshing];
    }else{
        [self.collectionView.mj_header endRefreshing];
    }
    [self.indicatorView stopAnimating];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index
{
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      insertedAtIndex:(NSInteger)index
{
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}


#pragma mark - public
- (void)reloadCollectionViewCell:(UICollectionViewCell *)cell
{
    if (!cell) {
        [self.collectionView reloadData];
        return;
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else{
        [self.collectionView reloadData];
    }
}



@end
