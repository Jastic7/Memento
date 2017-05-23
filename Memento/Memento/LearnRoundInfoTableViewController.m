//
//  LearnRoundInfoTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundInfoTableViewController.h"
#import "LearnRoundInfoTableViewCell.h"
#import "LearnRoundInfoHeader.h"
#import "Set.h"

static NSString * const kLearnRoundInfoHeaderID = @"LearnRoundInfoHeader";
static NSString * const kLearnRoundInfoTableViewCellID = @"LearnRoundInfoTableViewCell";


@interface LearnRoundInfoTableViewController () <UINavigationBarDelegate>

@property (strong, nonatomic) NSMutableArray <ItemOfSet *> *masteredItems;
@property (strong, nonatomic) NSMutableArray <ItemOfSet *> *learntItems;
@property (weak, nonatomic) IBOutlet UILabel *unknownLabel;
@property (weak, nonatomic) IBOutlet UILabel *learntLabel;
@property (weak, nonatomic) IBOutlet UILabel *masteredLabel;

@end

@implementation LearnRoundInfoTableViewController


#pragma mark - Getters 

- (NSMutableArray<ItemOfSet *> *)masteredItems {
    if (!_masteredItems) {
        _masteredItems = [self.roundSet itemsWithLearnState:Mastered];
    }
    
    return _masteredItems;
}

- (NSMutableArray<ItemOfSet *> *)learntItems {
    if (!_learntItems) {
        _learntItems = [self.roundSet  itemsWithLearnState:Learnt];
    }
    
    return _learntItems;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[LearnRoundInfoHeader nib] forHeaderFooterViewReuseIdentifier:kLearnRoundInfoHeaderID];
    [self configureCountLabels];
}


#pragma mark - Actions

- (IBAction)nextRoundButtonTapped:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformScale(self.view.transform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.navigationController willMoveToParentViewController:nil];
            [self.navigationController.view removeFromSuperview];
            [self.navigationController removeFromParentViewController];
            
            self.prepareForNextRoundBlock();
        }
    }];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    self.cancelingBlock();
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.masteredItems.count > 0 && self.learntItems.count > 0) {
        return 2;
    } else if (self.masteredItems.count == 0 && self.learntItems.count == 0) {
        return  0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = section == Mastered ? self.masteredItems.count : self.learntItems.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LearnRoundInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLearnRoundInfoTableViewCellID forIndexPath:indexPath];
    
    NSMutableArray <ItemOfSet *> *items = indexPath.section == Mastered ? self.masteredItems : self.learntItems;
    ItemOfSet *item = items[indexPath.row];
    
    [cell configureWithTerm:item.term definition:item.definition];
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LearnRoundInfoHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLearnRoundInfoHeaderID];
    
    NSString *headerTitle = section == Mastered ? @"Mastered" : @"Learnt";
    [header configureWithTitle:headerTitle];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


#pragma mark - Configuration

- (void)configureCountLabels {
    NSUInteger masteredCount    = [self.learningSet countItemsWithLearnState:Mastered];
    NSUInteger learntCount      = [self.learningSet countItemsWithLearnState:Learnt];
    NSUInteger unknownCount     = self.learningSet.count - masteredCount - learntCount;
    
    self.masteredLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)masteredCount];
    self.learntLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)learntCount];
    self.unknownLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)unknownCount];
}

#pragma mark - Helpers

-(void)dealloc {
    NSLog(@"Learn round info left");
}

@end
