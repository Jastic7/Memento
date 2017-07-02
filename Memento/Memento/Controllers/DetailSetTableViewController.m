//
//  DetailSetTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "DetailSetTableViewController.h"
#import "MatchPrepareViewController.h"
#import "LearnRoundViewController.h"
#import "ItemOfSetTableViewCell.h"

#import "Set.h"
#import "ItemOfSet.h"
#import "ServiceLocator.h"
#import "AlertPresenterProtocol.h"
#import "Assembly.h"

#import "LearnOrganizer.h"
#import "MatchOrganizer.h"

static NSString * const kItemOfSetCellID        = @"ItemOfSetTableViewCell";
static NSString * const kMatchModePrepareSegue  = @"matchModePrepareSegue";
static NSString * const kRoundLearnModeSegue    = @"roundLearnModeSegue";
static NSString * const kEditSetSegue           = @"editSetSegue";


@interface DetailSetTableViewController () <EditSetTableViewControllerDelegate>

@property (nonatomic, strong) ServiceLocator *serviceLocator;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation DetailSetTableViewController

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    
    return _alertPresenter;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.set.title;
    [self configureTableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.set.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID
                                                                   forIndexPath:indexPath];
    ItemOfSet *item = self.set[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell configureWithTerm:item.term
                 definition:item.definition
             speakerHandler:^(NSString *term, NSString *definition, ItemOfSetTableViewCell *cell) {
                 
                 __strong typeof(self)strongWeakSelf = weakSelf;
                 NSArray <NSString *> *words = @[term, definition];
                 NSArray <NSString *> *langs = @[strongWeakSelf.set.termLang, strongWeakSelf.set.definitionLang];
        
                 [strongWeakSelf.serviceLocator.speechService speakWords:words
                                                       withLanguageCodes:langs
                                                        speechStartBlock:^{ [cell activateSpeaker]; }
                                                          speechEndBlock:^{ [cell inactivateSpeaker]; }];
             }];
    return cell;
}


#pragma mark - EditSetTableViewControllerDelegate

- (void)editSetTableViewControllerDidCancelInEditingMode:(EditingMode)editingMode{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate editSetTableViewControllerDidCancelInEditingMode:editingMode];
    
}

- (void)editSetTableViewControllerDidEditSet:(Set *)set inEditingMode:(EditingMode)editingMode {
    [self.serviceLocator.setService postSet:set completion:^(NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Set doesn't updated" presentingController:self];
        }
    }];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate editSetTableViewControllerDidEditSet:set inEditingMode:editingMode];
    }];
}

- (void)editSetTableViewControllerDidDeleteSet:(Set *)set inEditingMode:(EditingMode)editingMode {
    NSString *setId = set.identifier;
    
    [self.serviceLocator.setService deleteSetWithId:setId completion:^(NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Deletion failed" presentingController:self];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate editSetTableViewControllerDidDeleteSet:set inEditingMode:editingMode];
            }];
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kMatchModePrepareSegue]) {
        MatchPrepareViewController *dvc = segue.destinationViewController;
        MatchOrganizer *matchModeOrganizer = [MatchOrganizer createWithSet:self.set];
        
        dvc.organizer = matchModeOrganizer;
        dvc.cancelBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
        
    } else if ([identifier isEqualToString:kRoundLearnModeSegue]) {
        LearnRoundViewController *dvc = segue.destinationViewController;
        LearnOrganizer *learnModeOrganizer = [LearnOrganizer createWithSet:self.set];
        
        learnModeOrganizer.delegate = dvc;
        
        dvc.organizer = learnModeOrganizer;
        dvc.cancelingBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
    
    } else if ([identifier isEqualToString:kEditSetSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        EditSetTableViewController *dvc = (EditSetTableViewController *)navController.topViewController;
        
        dvc.editableSet = self.set;
        dvc.delegate = self;
    }
}


#pragma mark - Private

- (void)uploadSet {
    [self.serviceLocator.setService postSet:self.set completion:^(NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Set doesn't updated" presentingController:self];
        }
    }];
}


#pragma mark - Configuration

- (void)configureTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
}

@end
