//
//  LNListDataAdaptor.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/20.
//

#import <Foundation/Foundation.h>

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


@protocol LNListDataAdaptor;
@protocol LNListDataProviderDelegate <NSObject>

@required
/** 请求完成回调*/
- (void)dataProvider:(id<LNListDataAdaptor>)provider
            loadType:(LNListDataLoadType)loadType
          loadStatus:(LNListDataLoadStatus)loadStatus
             message:(NSString *)message;
@optional
/**请求开始的回调*/
- (void)dataProvider:(id<LNListDataAdaptor>)provider
           loadStart:(LNListDataLoadType)requestType;

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      changedAtIndex:(NSInteger)index;

- (void)dataProvider:(id<LNListDataAdaptor>)provider
      deletedAtIndex:(NSInteger)index;

- (void)dataProvider:(id<LNListDataAdaptor>)provider
     insertedAtIndex:(NSInteger)index;

@end


@protocol LNListDataAdaptor <NSObject>

@property(nonatomic, assign, readonly) NSInteger currentPage;

@property(nonatomic, assign) NSInteger pageSize;

@property(nonatomic, weak) id<LNListDataProviderDelegate> delegate;

@property(nonatomic, assign, readonly) BOOL hasNextPage;

@property(nonatomic, assign, readonly) BOOL isInitial;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfObjectsInSection:(NSInteger)section;

- (NSArray *)sections;

- (NSArray *)dataListInSection:(NSInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

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



NS_ASSUME_NONNULL_END
