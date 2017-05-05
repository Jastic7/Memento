//
//  ViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SetsViewController.h"
#import "CreateSetViewController.h"
#import "DetailSetViewController.h"
#import "SetTableViewCell.h"
#import "Set.h"
#import "ItemOfSet.h"

static NSString * const kSetCellID = @"SetTableViewCell";
static NSString * const kCreateNewSetSegue = @"createNewSetSegue";
static NSString * const kDetailSetSegue = @"detailSetSegue";

@interface SetsViewController () <UITableViewDataSource, SaveSetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Set *> *sets;

@end

@implementation SetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sets = [NSMutableArray array];
    NSMutableArray<ItemOfSet *> *items = [NSMutableArray new];
    
    Set *set = [Set setWithTitle:@"Unit 8. Prepositions without translate translate translate translate translate translate translate" author:@"Jastioc7" items:items];
    [self.sets addObject:set];
    
    NSString *title = @"Unit 8. Prepositions without translate";
    NSString *author = @"Jastic7";
    
    set = [Set setWithTitle:title author:author items:items];
    [self.sets addObject:set];
    
    set = [Set setWithTitle:title author:author items:items];
    [self.sets addObject:set];
    
    set = [Set setWithTitle:title author:author items:items];
    [self.sets addObject:set];
    
    set = [Set setWithTitle:title author:author items:items];
    [self.sets addObject:set];
    
    set = [Set setWithTitle:title author:author items:items];
    [self.sets addObject:set];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetCellID forIndexPath:indexPath];
    Set *set = self.sets[indexPath.row];
    [cell configureWithTitle:set.title termsCount:set.count author:set.author];
    
    return cell;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:kCreateNewSetSegue]) {
        CreateSetViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if ([identifier isEqualToString:kDetailSetSegue]) {
        DetailSetViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        vc.set = self.sets[indexPath.row];
    }
}

-(void)cancelCreationalNewSet {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveNewSet:(Set *)set {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.sets addObject:set];
    [self.tableView reloadData];
}

@end
