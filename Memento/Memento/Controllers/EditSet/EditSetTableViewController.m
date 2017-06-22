//
//  EditSetTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditSetTableViewController.h"
#import "SelectedLanguagesTableViewController.h"
#import "InfoAlertViewController.h"

#import "EditingItemOfSetTableViewCell.h"
#import "AddItemTableViewCell.h"

#import "ItemOfSet.h"
#import "Set.h"

#import "UITableView+GettingIndexPath.h"


static NSString * const kEditingItemOfSetCellID = @"EditingItemOfSetTableViewCell";
static NSString * const kAddItemCellID = @"AddItemTableViewCell";
static NSString * const kSelectedLangSegue = @"selectedLanguagesSegue";



@interface EditSetTableViewController () <UINavigationBarDelegate, EditingItemOfSetTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleOfSetTextField;

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *termLanguage;
@property (nonatomic, copy) NSString *definitionLanguage;

@end


@implementation EditSetTableViewController

#pragma mark - Getters

- (NSMutableArray <ItemOfSet *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}

- (NSString *)author {
    if (!_author) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _author = [userDefaults objectForKey:@"userName"];
    }
    
    return _author;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.items.count) {
        AddItemTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:kAddItemCellID
                                                                        forIndexPath:indexPath];
        return addCell;
    }
    EditingItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditingItemOfSetCellID
                                                                          forIndexPath:indexPath];
    cell.delegate = self;
    
    ItemOfSet *item = self.items[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLastRowAtIndexPath:indexPath]) {
        [self addNewTermWithСompletion: ^void(NSIndexPath *insertedIndexPath) {
            [tableView scrollToRowAtIndexPath:insertedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            EditingItemOfSetTableViewCell *cell = [tableView cellForRowAtIndexPath:insertedIndexPath];
//            [cell becomeActive];
            
        }];
    }
}


#pragma mark - EditingItemOfSetTableViewCellDelegate

- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didChangeItemInTextView:(UITextView *)textView {
    [self updateSizeOfTextView:textView];
}

- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didEndEditingItemInTextView:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemOfSet *item = self.items[indexPath.row];
    
    if (textView.tag == 1000) {
        item.term = textView.text;
    } else if (textView.tag == 2000) {
        item.definition = textView.text;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.items.count - 1 inSection:0];
    EditingItemOfSetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell becomeActive];
    
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


#pragma mark - Actions

- (IBAction)configurationBarButtonTapped:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:kSelectedLangSegue sender:nil];
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"term != %@ && definition != %@", @"", @""];
    [self.items filterUsingPredicate:predicate];
    
    if (self.items.count == 0) {
        [self.delegate editSetTableViewControllerDidCancel];
        return;
    }
    
    if (![self isSetCorrect]) {
        return;
    }
    
    NSString *title = self.titleOfSetTextField.text;
    NSString *author = self.author;

    Set *set = [Set setWithTitle:title author:author definitionLang:self.definitionLanguage termLang:self.termLanguage items:self.items];
    
    [self.delegate editSetTableViewControllerDidEditSet:set];
    self.delegate = nil;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kSelectedLangSegue]) {
        SelectedLanguagesTableViewController *dvc = segue.destinationViewController;
        
        dvc.termLanguageCode = self.termLanguage;
        dvc.definitionLanguageCode = self.definitionLanguage;
        dvc.completionWithLanguages = ^(NSString *termLang, NSString *definitionLang) {
            self.termLanguage = termLang;
            self.definitionLanguage = definitionLang;
        };
    }
}


#pragma mark - Helpers

- (void)updateSizeOfTextView:(UITextView *)textView {
//    CGPoint currentOffset = self.tableView.contentOffset;
//    [UIView setAnimationsEnabled:NO];
//    
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//    
//    [UIView setAnimationsEnabled:YES];
//    [self.tableView setContentOffset:currentOffset];
}

- (BOOL)isSetCorrect {
    if (![self isTitleCorrect]) {
        [self showInfoAlertWithTitle:@"Error" message:@"Title of the new set should be non empty." dismissTitle:@"OK" handler:nil];
        return NO;
        
    } else if (![self isLanguagesSelected]) {
        [self showInfoAlertWithTitle:@"Error" message:@"You should select languages for terms and definitions" dismissTitle:@"Select language" handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:kSelectedLangSegue sender:nil];
        }];
        return NO;
    }
    
    return YES;
}


#pragma mark - Private

- (void)addNewTermWithСompletion:(void (^)(NSIndexPath *insertedIndexPath))completion {
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
    
    NSIndexPath *insertingIndexPath = [NSIndexPath indexPathForRow:self.items.count - 1 inSection:0];
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        completion(insertingIndexPath);
    }];
    
    [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[insertingIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [CATransaction commit];
}

- (void)showInfoAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                  dismissTitle:(NSString *)dismissTitle
                       handler:(void (^)(UIAlertAction *action))handler {
    
    InfoAlertViewController *infoAlert = [InfoAlertViewController alertControllerWithTitle:title message:message dismissTitle:dismissTitle handler:handler];
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (BOOL)isLastRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.items.count == indexPath.row;
}

- (BOOL)isLanguagesSelected {
    return (self.termLanguage != nil) && (self.definitionLanguage != nil);
}

- (BOOL)isTitleCorrect {
    return ![self.titleOfSetTextField.text isEqualToString:@""];
}


#pragma mark - Configuration

- (void)configureTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[EditingItemOfSetTableViewCell nib] forCellReuseIdentifier:kEditingItemOfSetCellID];
    [self.tableView registerNib:[AddItemTableViewCell nib] forCellReuseIdentifier:kAddItemCellID];
}


@end