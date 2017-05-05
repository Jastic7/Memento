//
//  CreateSetViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//
#import "CreateSetViewController.h"
#import "ItemOfSetTableViewCell.h"
#import "SaveSetDelegate.h"
#import "Set.h"
#import "ItemOfSet.h"
#import "UITableView+GettingIndexPath.h"

static NSString * const kItemOfSetCellID = @"ItemOfSetTableViewCell";

@interface CreateSetViewController () <UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *setTitleTextField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ItemOfSet *> *items;
@property (nonatomic, assign) NSUInteger countOfTerms;

@end

@implementation CreateSetViewController

#pragma mark - Getters

-(NSUInteger)countOfTerms {
    return self.items.count;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
    
    self.items = [NSMutableArray array];
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countOfTerms;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    ItemOfSet *item = self.items[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForSubview:textView];
    ItemOfSet *item = self.items[indexPath.row];
    
    if (textView.tag == 1000) {
        item.term = textView.text;
    } else {
        item.definition = textView.text;
    }
}

#pragma mark - End of creational

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    [self.delegate cancelCreationalNewSet];
    self.delegate = nil;
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    NSString *title = self.setTitleTextField.text;
    NSString *author = @"Jastic7";
    Set *set = [Set setWithTitle:title author:author items:self.items];
    
    [self.delegate saveNewSet:set];
    self.delegate = nil;
}

#pragma mark - Actions

- (IBAction)addNewTermTouchUpInside:(UIButton *)sender {
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
    
    [self.tableView reloadData];
}


@end
