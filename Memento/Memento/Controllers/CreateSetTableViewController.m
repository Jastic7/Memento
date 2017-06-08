//
//  CreateSetTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "CreateSetTableViewController.h"
#import "EditingItemOfSetTableViewCell.h"
#import "ItemOfSet.h"
#import "Set.h"
#import "UITableView+GettingIndexPath.h"

static NSString * const kEditingItemOfSetCellID = @"EditingItemOfSetTableViewCell";


@interface CreateSetTableViewController () <UINavigationBarDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray<ItemOfSet *> *items;
@property (nonatomic, weak) IBOutlet UITextField *titleOfSetTextField;

@end


@implementation CreateSetTableViewController

#pragma mark - Getters

- (NSMutableArray<ItemOfSet *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.titleOfSetTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditingItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditingItemOfSetCellID
                                                                          forIndexPath:indexPath];
    cell.delegate = self;
    
    ItemOfSet *item = self.items[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self updateSizeOfTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForSubview:textView];
    ItemOfSet *item = self.items[indexPath.row];
    
    if (textView.tag == 1000) {
        item.term = textView.text;
    } else {
        item.definition = textView.text;
    }
}


#pragma mark - Actions: Finish editing

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    [self.delegate сreateSetTableViewControllerDidCancel];
    self.delegate = nil;
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    NSString *title = self.titleOfSetTextField.text;
    NSString *author = @"Jastic7";
    
    if ([title isEqualToString:@""]) {
        [self showAlertWithTitle:@"Error" message:@"Title of the new set can't be empty."];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"term != %@ && definition != %@", @"", @""];
    [self.items filterUsingPredicate:predicate];
    
    //TODO:FIX IT
    Set *set = [Set setWithTitle:title author:author definitionLang:@"" termLang:@"" items:self.items];
    
    [self.delegate createSetTableViewControllerDidCreateSet:set];
    self.delegate = nil;
}


#pragma mark - Actions

- (IBAction)addNewTermTouchUpInside:(UIButton *)sender {
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
    
    [self.tableView beginUpdates];
    
    NSIndexPath *insertingIndexPath = [NSIndexPath indexPathForRow:self.items.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[insertingIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


#pragma mark - Helpers

- (void)updateSizeOfTextView:(UITextView *)textView {
    CGPoint currentOffset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView setAnimationsEnabled:YES];
    [self.tableView setContentOffset:currentOffset];
}


#pragma mark - Configuration

- (void)configureTableView {
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[EditingItemOfSetTableViewCell nib] forCellReuseIdentifier:kEditingItemOfSetCellID];
}


@end
