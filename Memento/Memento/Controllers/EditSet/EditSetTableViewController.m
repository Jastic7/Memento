
//  EditSetTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditSetTableViewController.h"
#import "SelectedLanguagesTableViewController.h"

#import "EditingItemOfSetTableViewCell.h"
#import "AddItemTableViewCell.h"

#import "ServiceLocator.h"
#import "AlertPresenterProtocol.h"
#import "ItemOfSet.h"
#import "Set.h"
#import "Assembly.h"

#import "UITableView+GettingIndexPath.h"
#import <BGTableViewRowActionWithImage/BGTableViewRowActionWithImage.h>


static NSString * const kEditingItemOfSetCellID = @"EditingItemOfSetTableViewCell";
static NSString * const kAddItemCellID          = @"AddItemTableViewCell";
static NSString * const kSelectedLangSegue      = @"selectedLanguagesSegue";


@interface EditSetTableViewController () <EditingItemOfSetTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleOfSetTextField;
@property (nonatomic, copy) NSString *termLanguage;
@property (nonatomic, copy) NSString *definitionLanguage;

@property (nonatomic, strong) NSMutableArray <ItemOfSet *> *items;
@property (nonatomic, strong) NSPredicate *emptyItemPredicate;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;
@property (nonatomic, strong) NSMutableCharacterSet *removingSymbols;

@property (nonatomic, assign) EditingMode editingMode;
@property (nonatomic, assign) BOOL isSetCorrect;

@end


@implementation EditSetTableViewController

#pragma mark - Getters

- (Set *)editableSet {
    if (!_editableSet) {
        NSString *author = [[ServiceLocator shared].userDefaultsService userName];
        _editableSet = [Set setWithTitle:nil author:author definitionLang:nil termLang:nil items:nil];
    }
    
    return _editableSet;
}

- (NSPredicate *)emptyItemPredicate {
    if (!_emptyItemPredicate) {
        _emptyItemPredicate = [NSPredicate predicateWithFormat:@"term != %@ && definition != %@", @"", @""];
    }
    
    return _emptyItemPredicate;
}

- (id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    
    return _alertPresenter;
}

- (NSCharacterSet *)removingSymbols {
    if (!_removingSymbols) {
        _removingSymbols = [NSMutableCharacterSet symbolCharacterSet];
        [_removingSymbols addCharactersInString:@" \n"];
    }
    return _removingSymbols;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    [self initializeProperties];
    
    ItemOfSet *item = [ItemOfSet new];
    [self.items addObject:item];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.items.count) {
        AddItemTableViewCell *addItemCell = [tableView dequeueReusableCellWithIdentifier:kAddItemCellID
                                                                        forIndexPath:indexPath];
        return addItemCell;
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
            [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isLastRowAtIndexPath:indexPath];
}


- (NSArray <UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger height = currentCell.frame.size.height;
    NSUInteger topOffset = 45;
    UIImage *image = [UIImage imageNamed:@"deleteRow"];
    UIColor *backgroundColor = tableView.backgroundColor;
    
    
    UITableViewRowAction *deleteAction = [BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                     title:@"Delete"
                                                                                titleColor:[UIColor blackColor]
                                                                           backgroundColor:backgroundColor
                                                                                     image:image
                                                                             forCellHeight:(height + topOffset)
                                                                                   handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.view endEditing:YES];
        [self.items removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    
    return @[deleteAction];
}


#pragma mark - EditingItemOfSetTableViewCellDelegate

- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didChangeItemInTextView:(UITextView *)textView {
    [self updateSizeOfTextView:textView];
}

- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didEndEditingItemInTextView:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForSubview:textView];
    ItemOfSet *item = self.items[indexPath.row];
    
    NSString *editedText = [self stringByTrimmingSpaces:textView.text];
    if (textView.tag == 1000) {
        item.term = editedText;
    } else if (textView.tag == 2000) {
        item.definition = editedText;
    }
}


#pragma mark - Actions

- (IBAction)configurationBarButtonTapped:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:kSelectedLangSegue sender:nil];
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    if ([self isEditCancel]) {
        [self.delegate editSetTableViewControllerDidCancelInEditingMode:self.editingMode];
        return;
    }
    
    if ([self isEditDelete]) {
        [self.delegate editSetTableViewControllerDidDeleteSet:self.editableSet inEditingMode:self.editingMode];
        return;
    }
    
    [self checkSet];
    if (self.isSetCorrect) {
        NSArray <ItemOfSet *> *filteredItems = [self.items filteredArrayUsingPredicate:self.emptyItemPredicate];
        
        NSString *title = self.titleOfSetTextField.text;
        [self.editableSet updateWithTitle:title termLang:self.termLanguage defLang:self.definitionLanguage items:[filteredItems mutableCopy]];
        
        [self.delegate editSetTableViewControllerDidEditSet:self.editableSet inEditingMode:self.editingMode];
        self.delegate = nil;
    }
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
        dvc.deleteSetCompletion = ^() {
//            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate editSetTableViewControllerDidDeleteSet:self.editableSet inEditingMode:self.editingMode];
        };
    }
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

- (void)checkSet {
    self.isSetCorrect = YES;
    
    if (![self isTitleCorrect]) {
        [self.alertPresenter showInfoMessage:@"Title of the new set should be non empty." title:@"Oops.." actionTitle:@"OK" handler:nil presentingController:self];
        self.isSetCorrect = NO;
        
    } else if (![self isLanguagesSelected]) {
        [self.alertPresenter showInfoMessage:@"You should select languages for terms and definitions"
                                       title:@"Oops.."
                                 actionTitle:@"Select language"
                                     handler:^(UIAlertAction *action) { [self performSegueWithIdentifier:kSelectedLangSegue sender:nil]; }
                        presentingController:self];
        self.isSetCorrect = NO;
    }
}

- (NSString *)stringByTrimmingSpaces:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:self.removingSymbols];
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

- (BOOL)isLastRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.items.count == indexPath.row;
}

- (BOOL)isLanguagesSelected {
    return (self.termLanguage != nil) && (self.definitionLanguage != nil);
}

- (BOOL)isTitleCorrect {
    return ![self.titleOfSetTextField.text isEqualToString:@""];
}

- (BOOL)isEditCancel {
    NSArray *filteredItems =  [self.items filteredArrayUsingPredicate:self.emptyItemPredicate];
    return ((self.editingMode == CreateNewSet) && (filteredItems.count == 0));
}

- (BOOL)isEditDelete {
    NSArray *filteredItems = [self.items filteredArrayUsingPredicate:self.emptyItemPredicate];
    return ((self.editingMode == EditExistingSet) && (filteredItems.count == 0));
}


#pragma mark - Configuration

- (void)configureTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[EditingItemOfSetTableViewCell nib] forCellReuseIdentifier:kEditingItemOfSetCellID];
    [self.tableView registerNib:[AddItemTableViewCell nib] forCellReuseIdentifier:kAddItemCellID];
}

- (void)initializeProperties {
    self.editingMode                = _editableSet == nil ? CreateNewSet : EditExistingSet;
    self.titleOfSetTextField.text   = self.editableSet.title;
    self.termLanguage               = self.editableSet.termLang;
    self.definitionLanguage         = self.editableSet.definitionLang;
    self.items                      = [self.editableSet.items mutableCopy];
}

@end
