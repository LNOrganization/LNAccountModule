//
//  LNBaseCollectionViewController.h
//  FBSnapshotTestCase
//
//  Created by Lenny on 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "LNBaseListDataProvider.h"
#import "LNBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LNBaseCollectionViewController : LNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, LNListDataProviderDelegate>

@property (nonatomic, strong) id<LNChildListDataAdaptor> provider;

@property (nonatomic, strong, readonly) NSArray *dataArray;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property(nonatomic, strong) UICollectionView *collectionView;

- (UICollectionView *)createCollectionView;

- (void)reloadCollectionViewCell:(UICollectionViewCell *)cell;


@end

NS_ASSUME_NONNULL_END
