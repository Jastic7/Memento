//
//  MatchItemsCollectionViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchItemsCollectionViewController.h"
#import "ItemOfMatchCollectionViewCell.h"
#import "MatchModeDelegate.h"

@interface MatchItemsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat itemsPerRow;
@property (nonatomic, assign) CGFloat itemsPerColumn;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@end

@implementation MatchItemsCollectionViewController

static NSString * const reuseIdentifier = @"ItemOfMatchCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsPerRow = 3;
    self.itemsPerColumn = 4;
    self.sectionInsets = UIEdgeInsetsMake(25, 10, 10, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat horizontalPaddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1);
    CGFloat verticalPaddingSpace = self.sectionInsets.top * (self.itemsPerColumn + 1);
    
    CGFloat avaliableWidthSize = self.view.frame.size.width - horizontalPaddingSpace;
    CGFloat widthPerItem = avaliableWidthSize / self.itemsPerRow;
    
    CGFloat avaliableHeightSize = self.view.frame.size.height - verticalPaddingSpace;
    CGFloat heightPerItem = avaliableHeightSize / self.itemsPerColumn;
    
    return CGSizeMake(widthPerItem, heightPerItem);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets.left;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfMatchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"matchHeader" forIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (IBAction)exitButtonTapped:(UIButton *)sender {
    [self.delegate exitMatchMode];
}

-(void)dealloc {
    NSLog(@"MATCH VC LEFT");
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
