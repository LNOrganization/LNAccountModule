//
//  LNBaseCollectionViewController.h
//  FBSnapshotTestCase
//
//  Created by Lenny on 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "LNListDataAdaptor.h"
#import "LNBaseViewController.h"
#import "LNCollectionViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNBaseCollectionViewController : LNBaseViewController<LNCollectionViewDataSource, UICollectionViewDelegate, LNListDataProviderDelegate>

@property (nonatomic, strong) id<LNListDataAdaptor> provider;

@end

NS_ASSUME_NONNULL_END
