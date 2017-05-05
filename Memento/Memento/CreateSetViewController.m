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
@property (nonatomic, copy) NSIndexPath *editingRow;
@property (nonatomic, assign) CGSize keyboardSize;

@end

@implementation CreateSetViewController

#pragma mark - Getters

-(NSUInteger)countOfTerms {
    return self.items.count;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNofifications];
    
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

-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.editingRow = [self.tableView indexPathForSubview:textView];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.keyboardSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    [self.tableView scrollToRowAtIndexPath:self.editingRow atScrollPosition:UITableViewScrollPositionBottom animated:true];
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

//TODO - endEditing before check empty textFields

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    NSString *title = self.setTitleTextField.text;
    NSString *author = @"Jastic7";
    
    if ([title isEqualToString:@""]) {
        [self showAlertWithTitle:@"Error" message:@"Title of the new set can't be empty."];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"term != %@ && definition != %@", @"", @""];
    [self.items filterUsingPredicate:predicate];
    
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

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - KeyboardNotifications;

-(void)registerForKeyboardNofifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

-(void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"DID SHOW SIZE: %f", keyboardSize.height);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    
    ItemOfSetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.editingRow];
    if (!CGRectContainsPoint(rect, cell.frame.origin)) {
        [((UIScrollView *)self.tableView) scrollRectToVisible:cell.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

@end
