//
//  LNCollectionViewDataSource.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNCollectionViewDataSource <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIView *errorView;

- (void)reloadCell:(UICollectionViewCell *)cell;

- (UICollectionViewFlowLayout *)layout;

@end

NS_ASSUME_NONNULL_END
