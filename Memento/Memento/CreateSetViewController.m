//
//  CreateSetViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//
#import "CreateSetViewController.h"
#import "ItemOfSetTableViewCell.h"
#import "CreationalNewSetDelegate.h"
#import "Set.h"

static NSString * const kItemOfSetCellID = @"ItemOfSetTableViewCell";

@interface CreateSetViewController () <UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *setTitleTextField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UITextField *> *termTextFields;
@property (nonatomic, strong) NSMutableArray<UITextField *> *definitionTextFields;

@property (nonatomic, assign) NSUInteger countOfTerms;

@end

@implementation CreateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
    
    
    self.countOfTerms = 1;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countOfTerms;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID forIndexPath:indexPath];
    cell.termTextView.delegate = self;
    cell.definitionTextView.delegate = self;
    return cell;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    [self.delegate cancelCreationalNewSet];
    self.delegate = nil;
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    NSMutableArray<ItemOfSet *> *items = [NSMutableArray new];
    Set *set = [Set setWithTitle:@"Unit 8. Prepositions without translate translate translate translate translate translate translate" author:@"Jastioc7" items:items];
    
    [self.delegate saveNewSet:set];
    self.delegate = nil;
}

- (IBAction)addNewTermTouchUpInside:(UIButton *)sender {
    self.countOfTerms++;
    [self.tableView reloadData];
}


@end
