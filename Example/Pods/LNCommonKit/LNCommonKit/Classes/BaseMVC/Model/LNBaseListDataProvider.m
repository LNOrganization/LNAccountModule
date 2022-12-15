//
//  LNBaseListDataProvider.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import "LNBaseListDataProvider.h"


@interface LNBaseListDataProvider ()

@property(nonatomic, assign, readwrite) NSInteger            currentPage;
@property(nonatomic, strong, readwrite) NSMutableArray       *dataList;
@property(nonatomic, assign, readwrite) BOOL                 hasNextPage;
@property(nonatomic, assign, readwrite) LNListDataLoadStatus  status;
@property(nonatomic, assign, readwrite) BOOL    isInitial;

@end

@implementation LNBaseListDataProvider

@synthesize delegate = _delegate, pageSize = _pageSize;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentPage = 1;
        self.pageSize = 20;
        _dataList = [[NSMutableArray alloc] init];
        _isInitial = YES;
       _hasNextPage = YES;
    }
    return self;
}

+ (instancetype)provider;
{
    LNBaseListDataProvider *provider = [[[self class] alloc] init];
    return provider;
}


#pragma mark -  public method

- (void)refreshData
{
    if (_status == LNListDataLoadStatusLoading && _currentPage != 1) {
        [self cancelRequestIfNeed];
        return;
    }
    _currentPage = 1;
    [self _innerLoadData];
}

- (void)loadMoreData
{
    if (self.status == LNListDataLoadStatusLoading) {
#if DEBUG
        NSLog(@"请求太频繁了");
#endif
        return;
    }
    [self _innerLoadData];
}

- (void)cancelRequestIfNeed
{
    if (self.currentPage > 1) {
        self.currentPage -= 1;
    }
    [LNRequestManager cancelRequest:self.request];
}

- (void)clearData
{
    [_dataList removeAllObjects];
    _currentPage = 0;
    _status = LNListDataLoadStatusNormal;
}


#pragma mark - private

- (void)_innerLoadData{
    _status = LNListDataLoadStatusLoading;
    LNListDataLoadType loadType = [self currentLoadType];
    [self callBackWhenStartWithLoadType:loadType];
    __weak typeof(self) weakSelf = self;
    self.request = [self requestWithSuccess:^(id  _Nullable data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleData:data loadType:loadType];
        [strongSelf callBackWithData:data loadType:loadType];
        strongSelf.isInitial = NO;
        strongSelf.currentPage += 1;
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleError:error loadType:loadType];
        [strongSelf callBackWithErrMsg:@"网络请求失败" loadType:loadType];
        strongSelf.isInitial = NO;
    }];
    
}

- (void)callBackWhenStartWithLoadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadStart:)]) {
            [self.delegate dataProvider:self loadStart:loadType];
        }
    });

}

- (void)callBackWithData:(NSArray *)dataList
                loadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadSucceed:requestType:)]) {
            [self.delegate dataProvider:self
                            loadSucceed:dataList
                            requestType:loadType];
        }
    });
}

- (void)callBackWithErrMsg:(NSString *)errMsg
                  loadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadFailed:requestType:)]) {
            [self.delegate dataProvider:self loadFailed:errMsg requestType:loadType];
        }
    });
}



- (LNListDataLoadType)currentLoadType
{
    LNListDataLoadType type = LNListDataLoadTypeInitial;
    if (!_isInitial) {
        if (_currentPage == 1) {
            type = LNListDataLoadTypeRefresh;
        }else{
            type = LNListDataLoadTypeLoadMore;
        }
    }
    return type;
}

#pragma mark - LNChildListDataProvider

- (LNHTTPRequest *)requestWithSuccess:(LNRequestSuccessBlock)success
                              failure:(LNRequestFailureBlock)failure
{
    NSLog(@"This method must be overwrite by subclass");
    return nil;
}

- (void)handleData:(NSArray *)dataList
          loadType:(LNListDataLoadType)loadType {
    self.status = LNListDataLoadStatusNormal;
    if (loadType != LNListDataLoadTypeLoadMore) {
        [self->_dataList removeAllObjects];
    }
    if ([dataList isKindOfClass:[NSArray class]] && dataList.count > 0) {
        [self->_dataList addObjectsFromArray:dataList];
        if (dataList.count < self.pageSize) {
            self.hasNextPage = NO;
        }else{
            self.hasNextPage = YES;
        }
    }else{
        if (loadType == LNListDataLoadTypeLoadMore) {
            self.status = LNListDataLoadStatusNoMore;
        }else{
            self.status = LNListDataLoadStatusEmpty;
        }
        self.hasNextPage = NO;
    }
}

- (void)handleError:(NSError *)error
          loadType:(LNListDataLoadType)loadType
{
#if DEBUG
    NSLog(@"请求失败：%@", error);
#endif
}

@end
