//
//  LNBaseListDataProvider.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import "LNBaseDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LNListDataLoadType) {
    LNListDataLoadTypeInitial,
    LNListDataLoadTypeRefresh,
    LNListDataLoadTypeLoadMore
};

typedef NS_ENUM(NSUInteger, LNListDataLoadStatus) {
    LNListDataLoadStatusNormal,
    LNListDataLoadStatusLoading,
    LNListDataLoadStatusError,
    LNListDataLoadStatusNoMore,
    LNListDataLoadStatusEmpty
};


@protocol  LNChildListDataAdaptor;

@protocol LNListDataProviderDelegate <NSObject>

/** 请求成功回调*/
- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
         loadSucceed:(NSArray *)data
         requestType:(LNListDataLoadType)requestType;
/** 请求失败回调*/
- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
          loadFailed:(NSString *)errMsg
         requestType:(LNListDataLoadType)requestType;
@optional
/**请求开始的回调*/
- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType;

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index;

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index;

- (void)dataProvider:(id<LNChildListDataAdaptor>)provider
     insertedAtIndex:(NSInteger)index;

@end



@protocol LNChildListDataAdaptor <NSObject>

@property(nonatomic, assign, readonly) NSInteger currentPage;

@property(nonatomic, assign) NSInteger pageSize;

@property(nonatomic, strong, readonly) NSArray *dataList;

@property(nonatomic, weak) id<LNListDataProviderDelegate> delegate;

@property(nonatomic, assign, readonly) BOOL hasNextPage;

@property(nonatomic, assign, readonly) BOOL isInitial;

/*
 * 请求第一页 或 刷新
 */
- (void)refreshData;

/*
 * 加载下一页
 */
- (void)loadMoreData;

/*
 * 清除数据
 */
- (void)clearData;

/*
 * 取消请求
 */
- (void)cancelRequestIfNeed;


@end





@interface LNBaseListDataProvider : LNBaseDataProvider<LNChildListDataAdaptor>



@end

NS_ASSUME_NONNULL_END
