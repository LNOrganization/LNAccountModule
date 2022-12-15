//
//  LNBaseGroupDataProvider.m
//  LNFeedModule
//
//  Created by Lenny on 2022/7/26.
//

#import "LNBaseGroupDataProvider.h"

@interface LNBaseGroupDataProvider ()

@property(nonatomic, strong, readwrite) NSMutableDictionary *dataDict;
@property(nonatomic, strong, readwrite) NSMutableArray      *sections;
@property(nonatomic, assign, readwrite) BOOL                 hasNextPage;

@end


@implementation LNBaseGroupDataProvider

@synthesize hasNextPage = _hasNextPage;

- (void)handleData:(NSDictionary *)data
       requestType:(LNListDataLoadType)requestType
{
    if (requestType != LNListDataLoadTypeLoadMore) {
        [self->_dataDict removeAllObjects];
    }
    if ([data isKindOfClass:[NSDictionary class]] && data.count > 0) {
        NSArray *sections = [data objectForKey:@"sections"];
        [self->_sections addObjectsFromArray:sections];
        [self->_dataDict addEntriesFromDictionary:data];
        if (data.count < self.pageSize) {
            self.hasNextPage = NO;
        }else{
            self.hasNextPage = YES;
        }
    }else{
        self.hasNextPage = NO;
    }
}

- (nonnull NSArray *)dataListInSection:(NSInteger)section {
    if (self.dataList && self.dataList.count > section) {
        NSArray *sectionDatas = self.dataList[section];
        if (sectionDatas && [sectionDatas isKindOfClass:[NSArray class]]) {
            return sectionDatas;
        }
    }
    return self.dataList;
}

- (nonnull id)objectAtIndex:(NSInteger)index inSection:(NSInteger)section {
    NSArray *arr = [self dataListInSection:section];
    id obj = nil;
    if (arr && arr.count > index) {
        obj = arr[index];
    }
    return obj;
}



@end
