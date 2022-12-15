//
//  LNBaseGroupDataProvider.h
//  LNFeedModule
//
//  Created by Lenny on 2022/7/26.
//

#import "LNBaseListDataProvider.h"
NS_ASSUME_NONNULL_BEGIN

@interface LNBaseGroupDataProvider : LNBaseListDataProvider


@property(nonatomic, strong, readonly) NSArray *sections;
/*
 * 分组数据获取，请求结束之后同步读取
 */
- (NSArray *)dataListInSection:(NSInteger)section;

- (id)objectAtIndex:(NSInteger)index inSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
