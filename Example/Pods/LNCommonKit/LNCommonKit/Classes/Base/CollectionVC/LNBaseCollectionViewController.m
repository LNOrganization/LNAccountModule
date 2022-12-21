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

- (void)setProvider:(id<LNListDataAdaptor>)provider
{
    _provider = provider;
    _provider.delegate = self;
}

#pragma mark - LNCollectionViewDataSource

@synthesize collectionView = _collectionView;

@synthesize dataArray = _dataArray;

@synthesize errorView = _errorView;

@synthesize indicatorView = _indicatorView;

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
        _indicatorView.center = CGPointMake(LNScreenWidth/2, LNScreenHeight/2);
        _indicatorView.color = [UIColor grayColor];
    }
    return _indicatorView;
}

- (NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [self.provider dataListInSection:0];
    }
    return _dataArray;
}

- (void)reloadCell:(UICollectionViewCell *)cell
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

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


#pragma mark -  LNListDataProviderDelegate
- (void)dataProvider:(id<LNListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType
{
    [self.indicatorView startAnimating];
}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
            loadType:(LNListDataLoadType)loadType
          loadStatus:(LNListDataLoadStatus)loadStatus
             message:(NSString *)message
{
    [self finishLoading:loadType];
    [self.collectionView reloadData];
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

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index
{
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      insertedAtIndex:(NSInteger)index
{
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}


@end
