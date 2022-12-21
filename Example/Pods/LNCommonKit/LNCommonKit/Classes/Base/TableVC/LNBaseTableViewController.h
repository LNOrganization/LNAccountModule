//
//  LNBaseTableViewController.h
//  ArchitectureDesign
//
//  Created by Lenny on 2021/8/30.
//

#import <UIKit/UIKit.h>
#import "LNListDataAdaptor.h"
#import "LNBaseViewController.h"
#import "LNTableViewDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface LNBaseTableViewController : LNBaseViewController<LNTableViewDataSource, UITableViewDelegate, LNListDataProviderDelegate>

@property (nonatomic, strong) id<LNListDataAdaptor> provider;


@end

NS_ASSUME_NONNULL_END
