//
//  ViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ViewController.h"
#import "SetTableViewCell.h"
#import "Set.h"
@interface ViewController () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Set *> *sets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sets = [NSMutableArray array];
    
    Set *set = [Set new];
    set.title = @"Unit 8. Prepositions without translate translate translate translate translate translate translate";
    set.author = @"Jastic7";
    set.count = 123;
    [self.sets addObject:set];
    
    set = [Set new];
    set.title = @"Unit 8. Prepositions without translate";
    set.author = @"Jastic7";
    set.count = 123;
    [self.sets addObject:set];
    
    set = [Set new];
    set.title = @"Unit 8. Prepositions without translate";
    set.author = @"Jastic7";
    set.count = 123;
    [self.sets addObject:set];
    
    set = [Set new];
    set.title = @"Unit 8. Prepositions without translate";
    set.author = @"Jastic7";
    set.count = 123;
    [self.sets addObject:set];
    
    set = [Set new];
    set.title = @"Unit 8. Prepositions without translate";
    set.author = @"Jastic7";
    set.count = 123;
    [self.sets addObject:set];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
    Set *set = self.sets[indexPath.row];
    [cell configureWithTitle:set.title termsCount:set.count author:set.author];
    
    return cell;
}

@end
