//
//  LNBaseListDataProvider.m
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import "LNBaseListDataProvider.h"
#import "LNConsttant.h"
#import "LNNetworkManager.h"
#import "LNResponse.h"

@interface LNBaseListDataProvider ()

@property(nonatomic, assign, readwrite) BOOL                 isInitial;
@property(nonatomic, assign, readwrite) BOOL                 hasNextPage;
@property(nonatomic, assign, readwrite) NSInteger            currentPage;
@property(nonatomic, strong, readwrite) NSMutableArray       *dataList;
@property(nonatomic, assign, readwrite) LNListDataLoadStatus status;
@property(nonatomic, strong) NSMutableDictionary  *dataDict;
@property(nonatomic, strong) NSMutableOrderedSet   *sectionsOrderSet;

@end

@implementation LNBaseListDataProvider

@synthesize delegate = _delegate, pageSize = _pageSize;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentPage = 1;
        self.pageSize = 20;
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

- (NSMutableArray *)dataList
{
    if(!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableDictionary *)dataDict
{
    if(!_dataDict){
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

#pragma mark -  public method
#pragma mark -  load
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
    [LNNetworkManager cancelRequest:self.request];
}

- (void)clearData
{
    [_dataList removeAllObjects];
    _currentPage = 0;
    _status = LNListDataLoadStatusNormal;
}

#pragma mark -  data read
- (NSInteger)numberOfSections{
    if([self isGroup]){
        return self.sectionsOrderSet.count;
    }
    return 1;
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)section{
    if([self isGroup]){
        if(self.sectionsOrderSet.count > section){
            NSString *key = self.sectionsOrderSet[section];
            NSArray *dataList = _dataDict[key];
            if([dataList isKindOfClass:[NSArray class]]){
                return dataList.count;
            }
        }
    }
    return _dataList.count;
}

- (NSArray *)sections
{
    return self.sectionsOrderSet.array;
}

- (NSArray *)dataListInSection:(NSInteger)section
{
    if([self isGroup]){
        if(self.sectionsOrderSet.count > section){
            NSString *key = self.sectionsOrderSet[section];
            NSArray *dataList = _dataDict[key];
            if([dataList isKindOfClass:[NSArray class]]){
                return dataList;
            }
        }
    }
    return _dataList ? _dataList : @[];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self isGroup]){
        NSInteger section = indexPath.section;
        if(self.sectionsOrderSet.count > section){
            NSString *key = self.sectionsOrderSet[section];
            NSArray *dataList = _dataDict[key];
            if([dataList isKindOfClass:[NSArray class]] && dataList.count > indexPath.row){
                return dataList[indexPath.row];
            }
        }
    }
    if(self.dataList.count > indexPath.row){
        return self.dataList[indexPath.row];

    }
    return nil;
}

- (BOOL)isGroup
{
    return ([self responseClass] == [LNGroupJSONResponse class]);
}

#pragma mark - private

- (void)_innerLoadData{
    _status = LNListDataLoadStatusLoading;
    LNListDataLoadType loadType = [self currentLoadType];
    [self callBackWhenStartWithLoadType:loadType];
    __weak typeof(self) weakSelf = self;
    self.request = [self requestWithSuccess:^(id  _Nullable data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponse:data loadType:loadType];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleError:error loadType:loadType];
    }];
    
}

#pragma mark - handle response
- (void)handleResponse:(id)data
              loadType:(LNListDataLoadType)loadType {
    
    if([data isKindOfClass:[NSDictionary class]]){
        if ([self isGroup]) {
            LNGroupJSONResponse *groupJSONResponse = [LNGroupJSONResponse responseWithDictionary:data modelClass:[self modelClass]];
            [self handleGroupData:groupJSONResponse loadType:loadType];
        }else{
            LNListJSONResponse *listJSONResponse = [LNListJSONResponse responseWithDictionary:data modelClass:[self modelClass]];
            [self handleListData:listJSONResponse loadType:loadType];
        }
    }else{
        if ([data isKindOfClass:[LNGroupJSONResponse class]]) {
            [self handleGroupData:(LNGroupJSONResponse *)data loadType:loadType];
        }else if([data isKindOfClass:[LNListJSONResponse class]]){
            [self handleListData:(LNListJSONResponse *)data loadType:loadType];
        }else{
            NSError *error = [NSError errorWithDomain:NSParseErrorException code:0 userInfo:@{@"reason" : @"Invalid data"}];
            [self handleError:error loadType:loadType];
        }
    }
    self.isInitial = NO;
    self.currentPage += 1;
}

- (void)handleListData:(LNListJSONResponse *)response
              loadType:(LNListDataLoadType)loadType {
    
    LNListDataLoadStatus status = LNListDataLoadStatusNormal;
    NSArray *dataList = response.dataList;
    if ([response isSucceed] && loadType != LNListDataLoadTypeLoadMore) {
        [self.dataList removeAllObjects];
    }
    if (response && [response isSucceed]) {
        [self.dataList addObjectsFromArray:dataList];
        if (dataList.count < self.pageSize) {
            self.hasNextPage = NO;
        }else{
            self.hasNextPage = YES;
        }
        if(dataList.count > 0){
            status = LNListDataLoadStatusNormal;
        }else{
            if (loadType == LNListDataLoadTypeLoadMore) {
                status = LNListDataLoadStatusNoMore;
            }else{
                status = LNListDataLoadStatusEmpty;
            }
        }
        [self callBackWithResponse:response loadStatus:status loadType:loadType];
    }else{
        status = LNListDataLoadStatusError;
        if(response){
            [self callBackWithResponse:response loadStatus:status loadType:loadType];
        }else{
            NSError *error = [NSError errorWithDomain:NSParseErrorException code:0 userInfo:@{@"reason" : @"Invalid data"}];
            [self handleError:error loadType:loadType];
        }
    }
    self.status = status;
}

- (void)handleGroupData:(LNGroupJSONResponse *)response
               loadType:(LNListDataLoadType)loadType {
    
    LNListDataLoadStatus status = LNListDataLoadStatusNormal;
    if (response && [response isSucceed] ) {
        NSDictionary *dataDict = response.dataDict;
        NSArray *sections = response.sections;
        if(loadType != LNListDataLoadTypeLoadMore){
            [self.dataDict removeAllObjects];
            [_sectionsOrderSet removeAllObjects];
        }
        if([sections isKindOfClass:[NSArray class]]){
            [_sectionsOrderSet addObjectsFromArray:sections];
        }
        [self.dataDict addEntriesFromDictionary:dataDict];
        if (dataDict.count < self.pageSize) {
            self.hasNextPage = NO;
        }else{
            self.hasNextPage = YES;
        }
        if(dataDict.count > 0){
            status = LNListDataLoadStatusNormal;
        }else{
            if(loadType == LNListDataLoadTypeLoadMore){
                status = LNListDataLoadStatusNoMore;
            }else{
                status = LNListDataLoadStatusEmpty;
            }
        }
        [self callBackWithResponse:response loadStatus:status loadType:loadType];
    }else{
        status = LNListDataLoadStatusError;
        if(response){
            [self callBackWithResponse:response loadStatus:status loadType:loadType];
        }else{
            NSError *error = [NSError errorWithDomain:NSParseErrorException code:0 userInfo:@{@"reason" : @"Invalid data"}];
            [self handleError:error loadType:loadType];
        }
    }
    self.status = status;
}

- (void)handleError:(NSError *)error
          loadType:(LNListDataLoadType)loadType
{
    self.isInitial = NO;
    self.status = LNListDataLoadStatusError;
    NSString *errMsg = @"网络请求失败";
#if DEBUG
    NSLog(@"请求失败：%@", error);
#endif
    [self callBackWithErrMsg:errMsg loadType:loadType];
}



- (void)callBackWhenStartWithLoadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadStart:)]) {
            [self.delegate dataProvider:self loadStart:loadType];
        }
    });

}

- (void)callBackWithResponse:(LNResponse *)response
                  loadStatus:(LNListDataLoadStatus)status
                    loadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadType:loadStatus:message:)]) {
            [self.delegate dataProvider:self
                               loadType:loadType
                             loadStatus:status
                                message:response.message];
        }
    });
}

- (void)callBackWithErrMsg:(NSString *)errMsg
                  loadType:(LNListDataLoadType)loadType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataProvider:loadType:loadStatus:message:)]) {
            [self.delegate dataProvider:self
                               loadType:loadType
                             loadStatus:LNListDataLoadStatusError
                                message:errMsg];
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

#pragma mark - LNDataProviderAdaptor

- (LNHTTPRequest *)requestWithSuccess:(LNLoadSuccessBlock)success
                              failure:(LNLoadFailureBlock)failure{
    NSLog(@"This method must be overwrite by subclass");
    return nil;
}

- (Class)responseClass{
    return [LNListJSONResponse class];
}

@end
