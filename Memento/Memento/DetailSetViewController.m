//
//  DetailSetViewController.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "DetailSetViewController.h"
#import "ItemOfSetTableViewCell.h"
#import "Set.h"
#import "ItemOfSet.h"

static NSString * const kItemOfSetCellID = @"ItemOfSetTableViewCell";

@interface DetailSetViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
    
    NSLog(@"SET IS : %@", self.set);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.set.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID forIndexPath:indexPath];
    ItemOfSet *item = self.set[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}

@end
