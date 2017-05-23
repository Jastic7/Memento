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

@property (strong, nonatomic) NSMutableDictionary <NSString *, Set *> *structuredSet;

@end

@implementation LearnRoundInfoTableViewController


#pragma mark - Getters 

- (NSMutableDictionary<NSString *,Set *> *)structuredSet {
    if (!_structuredSet) {
        _structuredSet = [NSMutableDictionary dictionary];
        _structuredSet[@"Learnt"] = [self.roundSet itemsWithLearnState:Learnt];
        _structuredSet[@"Mastered"] = [self.roundSet itemsWithLearnState:Mastered];
    }
    
    return _structuredSet;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[LearnRoundInfoHeader nib] forHeaderFooterViewReuseIdentifier:kLearnRoundInfoHeaderID];
}


- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    self.cancelingBlock();
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.structuredSet.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *typeOfSection = section == 1 ? @"Learnt" : @"Mastered";
    return self.structuredSet[typeOfSection].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LearnRoundInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLearnRoundInfoTableViewCellID forIndexPath:indexPath];
    NSString *typeOfSection = indexPath.section == 1 ? @"Learnt" : @"Mastered";
    Set *currentSet = self.structuredSet[typeOfSection];
    ItemOfSet *item = currentSet[indexPath.row];
    
    [cell configureWithTerm:item.term definition:item.definition];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LearnRoundInfoHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLearnRoundInfoHeaderID];
    NSString *headerTitle = section == 1 ? @"Learnt" : @"Mastered";
    [header configureWithTitle:headerTitle];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(void)dealloc {
    NSLog(@"Learn round info left");
}

@end
