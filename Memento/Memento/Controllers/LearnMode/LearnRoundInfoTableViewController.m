//
//  LearnRoundInfoTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundInfoTableViewController.h"
#import "ItemOfSetTableViewCell.h"
#import "LearnRoundInfoHeader.h"
#import "UIColor+PickerColors.h"
#import "Set.h"

static NSString * const kLearnRoundInfoHeaderID = @"LearnRoundInfoHeader";
static NSString * const kItemOfSetTableViewCellID = @"ItemOfSetTableViewCell";


@interface LearnRoundInfoTableViewController () <UINavigationBarDelegate>

@property (strong, nonatomic) NSMutableArray <ItemOfSet *> *unknownItems;
@property (strong, nonatomic) NSMutableArray <ItemOfSet *> *learntItems;
@property (strong, nonatomic) NSMutableArray <ItemOfSet *> *masteredItems;
@property (strong, nonatomic) NSMutableArray <NSMutableArray <ItemOfSet *> *> *items;
@property (strong, nonatomic) NSMutableArray <NSString *> *titles;

@property (weak, nonatomic) IBOutlet UIButton *learnRoundButton;
@property (weak, nonatomic) IBOutlet UILabel *unknownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *learntCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *masteredCountLabel;

@end

@implementation LearnRoundInfoTableViewController


#pragma mark - Getters

- (NSMutableArray<ItemOfSet *> *)unknownItems {
    if (!_unknownItems) {
        _unknownItems = [self.roundSet itemsWithLearnState:Unknown];
    }
    
    return _unknownItems;
}

- (NSMutableArray<ItemOfSet *> *)learntItems {
    if (!_learntItems) {
        _learntItems = [self.roundSet  itemsWithLearnState:Learnt];
    }
    
    return _learntItems;
}

- (NSMutableArray<ItemOfSet *> *)masteredItems {
    if (!_masteredItems) {
        _masteredItems = [self.roundSet itemsWithLearnState:Mastered];
    }
    
    return _masteredItems;
}

- (NSMutableArray<NSMutableArray<ItemOfSet *> *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
        
        if (self.unknownItems.count != 0) {
            [_items addObject:self.unknownItems];
            [self.titles addObject:@"Unknown"];
        }
        
        if (self.learntItems.count != 0) {
            [_items addObject:self.learntItems];
            [self.titles addObject:@"Learnt"];
        }
        
        if (self.masteredItems.count != 0) {
            [_items addObject:self.masteredItems];
            [self.titles addObject:@"Mastered"];
        }
    }
    
    return _items;
}

- (NSMutableArray<NSString *> *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    
    return _titles;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerNibs];
    [self configureCountLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isLearningFinished) {
        [self.learnRoundButton setTitle:@"Start over" forState:UIControlStateNormal];
    }
}


#pragma mark - Actions

- (IBAction)nextRoundButtonTapped:(UIButton *)sender {
    self.prepareForNextRoundBlock();
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformScale(self.view.transform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.navigationController willMoveToParentViewController:nil];
            [self.navigationController.view removeFromSuperview];
            [self.navigationController removeFromParentViewController];
        }
    }];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    self.cancelingBlock();
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetTableViewCellID forIndexPath:indexPath];
    
    ItemOfSet *item = self.items[indexPath.section][indexPath.row];
    
    UIColor *textColor = item.learnProgress == Unknown ? [UIColor failedColor] : [UIColor textBlack];
    [cell configureWithTerm:item.term definition:item.definition textColor:textColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LearnRoundInfoHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLearnRoundInfoHeaderID];
    NSString *headerTitle = self.titles[section];
    [header configureWithTitle:headerTitle];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


#pragma mark - Configuration

- (void)configureCountLabels {
    NSUInteger masteredCount     = [self.set countItemsWithLearnState:Mastered];
    NSUInteger learntCount       = [self.set countItemsWithLearnState:Learnt];
    NSUInteger unknownCount      = self.set.count - masteredCount - learntCount;
    
    self.masteredCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)masteredCount];
    self.learntCountLabel.text   = [NSString stringWithFormat:@"%lu", (unsigned long)learntCount];
    self.unknownCountLabel.text  = [NSString stringWithFormat:@"%lu", (unsigned long)unknownCount];
}

- (void)registerNibs {
    [self.tableView registerNib:[LearnRoundInfoHeader nib] forHeaderFooterViewReuseIdentifier:kLearnRoundInfoHeaderID];
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetTableViewCellID];
}

#pragma mark - Helpers

- (void)dealloc {
    NSLog(@"Learn round info left");
}

@end
