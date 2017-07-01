//  MatchItemsCollectionViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchItemsCollectionViewController.h"
#import "ItemOfMatchCollectionViewCell.h"
#import "MatchHeaderCollectionReusableView.h"

#import "Set.h"
#import "ItemOfSet.h"
#import "NSMutableArray+Shuffle.h"
#import "UIColor+PickerColors.h"


static NSString * const reuseIdentifier = @"ItemOfMatchCollectionViewCell";


@interface MatchItemsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat itemsPerRow;
@property (nonatomic, assign) CGFloat itemsPerColumn;
@property (nonatomic, assign) CGFloat borderWidthForItem;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/*!
 * @brief Contains pairs of terms and definitions
 * from round set for representing in collection view.
 */
@property (nonatomic, strong) NSMutableArray <NSString *> *matchingItems;
@property (nonatomic, strong) NSMutableArray <NSString *> *selectedItems;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *guessedItems;
@property (nonatomic, weak) MatchHeaderCollectionReusableView *matchHeader;

@end

@implementation MatchItemsCollectionViewController

#pragma mark - Getters

- (NSMutableArray <NSString *> *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    return _selectedItems;
}

- (NSMutableArray <NSString *> *)randomItems {
    if (!_matchingItems) {
        _matchingItems = [NSMutableArray array];
    }
    
    return _matchingItems;
}

- (NSMutableArray <NSIndexPath *> *)guessedItems {
    if (!_guessedItems) {
        _guessedItems = [NSMutableArray array];
    }
    
    return _guessedItems;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
    [self.organizer updateRoundSet];
}


#pragma mark - MatchModeOrganizerDelegate

- (void)matchOrganizerDidFinishedMatching:(id <MatchOrganizerProtocol>)matchOrganizer {
    NSString *timeResult = [self.matchHeader stopTimer];
    [UIView animateWithDuration:0.3 animations:^{
        self.finishMatchBlock(timeResult);
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformScale(self.view.transform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self willMoveToParentViewController:nil];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
}

- (void)matchOrganizer:(id <MatchOrganizerProtocol>)matchOrganizer didObtainedRandomItems:(NSMutableArray<NSString *> *)randomItems {
    NSMutableArray<NSIndexPath *> *removingIndexies = [NSMutableArray array];
    for (int i = 0; i < self.matchingItems.count; i++) {
        [removingIndexies addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    NSMutableArray<NSIndexPath *> *insertingIndexies = [NSMutableArray array];
    for (int i = 0; i < randomItems.count; i++) {
        [insertingIndexies addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:removingIndexies];
        self.matchingItems = randomItems;
        [self.collectionView insertItemsAtIndexPaths:insertingIndexies];
    } completion:nil];   
}

- (void)matchOrganizer:(id <MatchOrganizerProtocol>)matchOrganizer didCheckedSelectedItemsWithResult:(BOOL)isMatched {
    NSArray<NSIndexPath *> *selectedIndexPaths = self.collectionView.indexPathsForSelectedItems;
    
    if (isMatched) {
        [self hideItemsAtIndexPaths:selectedIndexPaths];
    } else {
        for (NSIndexPath *idx in selectedIndexPaths) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:idx];
            cell.backgroundColor = [UIColor failedStateColor];
            
            [self.collectionView deselectItemAtIndexPath:idx animated:YES];
            cell.backgroundColor = [UIColor unknownStateColor];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.matchingItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfMatchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor unknownStateColor];
    cell.alpha = 1.0;
    
    NSString *randomItem = self.matchingItems[indexPath.row];
    [cell configureWithText:randomItem borderWidth:self.borderWidthForItem];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MatchHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"matchHeader" forIndexPath:indexPath];
        headerView.cancelBlock = self.cancelBlock;
        self.matchHeader = headerView;
        return headerView;
    } else {
        return nil;
    }
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return ![self.guessedItems containsObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = self.matchingItems[indexPath.row];
    [self.selectedItems addObject:selectedItem];
    
    if (self.selectedItems.count == 2) {
        [self.organizer checkSelectedItems:self.selectedItems];
        [self.selectedItems removeAllObjects];
        
        if (self.guessedItems.count == self.matchingItems.count) {
            [self.guessedItems removeAllObjects];
            [self.organizer updateRoundSet];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deselectedItem = self.matchingItems[indexPath.row];
    [self.selectedItems removeObject:deselectedItem];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat horizontalPaddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1);
    CGFloat verticalPaddingSpace = self.sectionInsets.top * (self.itemsPerColumn + 1);
    
    CGFloat sizeForBordersPerColumn = self.borderWidthForItem * self.itemsPerColumn * 2;
    CGFloat sizeForBordersPerRow = self.borderWidthForItem * self.itemsPerRow * 2;
    
    CGFloat avaliableWidthSize = self.view.frame.size.width - horizontalPaddingSpace - sizeForBordersPerColumn;
    CGFloat widthPerItem = avaliableWidthSize / self.itemsPerRow;
    
    CGFloat avaliableHeightSize = self.view.frame.size.height - verticalPaddingSpace - sizeForBordersPerRow;
    CGFloat heightPerItem = avaliableHeightSize / self.itemsPerColumn;
    
    return CGSizeMake(widthPerItem, heightPerItem);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets.left;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateCollectionViewFlowLayout];
}


#pragma mark - Helpers

- (void)hideItemsAtIndexPaths:(NSArray <NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor learntStateColor];
        
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }];
    }
    
    [self.guessedItems addObjectsFromArray:indexPaths];
}

- (void)updateCollectionViewFlowLayout {
    BOOL isLandscapeOrientation = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    if (isLandscapeOrientation) {
        self.itemsPerRow = 4;
        self.itemsPerColumn = 3;
    } else {
        self.itemsPerRow = 3;
        self.itemsPerColumn = 4;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
}


#pragma mark - Configuration

- (void)configure {
    self.itemsPerRow = 3;
    self.itemsPerColumn = 4;
    self.borderWidthForItem = 1.0;
    self.sectionInsets = UIEdgeInsetsMake(25, 10, 10, 10);
    
    self.collectionView.allowsMultipleSelection = YES;
}

@end
