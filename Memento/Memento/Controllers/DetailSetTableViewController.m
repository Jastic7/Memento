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
#import "EditSetTableViewController.h"
#import "ItemOfSetTableViewCell.h"

#import "Set.h"
#import "ItemOfSet.h"
#import "ServiceLocator.h"

#import "LearnOrganizer.h"
#import "MatchOrganizer.h"

static NSString * const kItemOfSetCellID        = @"ItemOfSetTableViewCell";
static NSString * const kMatchModePrepareSegue  = @"matchModePrepareSegue";
static NSString * const kRoundLearnModeSegue    = @"roundLearnModeSegue";
static NSString * const kEditSetSegue           = @"editSetSegue";


@interface DetailSetTableViewController () <EditSetTableViewControllerDelegate>

@property (nonatomic, strong) ServiceLocator *serviceLocator;

@end

@implementation DetailSetTableViewController

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self uploadSet];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.set.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID
                                                                   forIndexPath:indexPath];
    ItemOfSet *item = self.set[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell configureWithTerm:item.term definition:item.definition speakerHandler:^(NSString *term, NSString *definition, ItemOfSetTableViewCell *cell) {
        __strong typeof(self)strongWeakSelf = weakSelf;
        
        NSArray <NSString *> *words = @[term, definition];
        NSArray <NSString *> *langs = @[strongWeakSelf.set.termLang, strongWeakSelf.set.definitionLang];
        
        [strongWeakSelf.serviceLocator.speechService speakWords:words
                                    withLanguageCodes:langs
                                     speechStartBlock:^{ [cell activateSpeaker]; }
                                       speechEndBlock:^{ [cell inactivateSpeaker]; }
         ];
    }];
    
    return cell;
}


#pragma mark - EditSetTableViewControllerDelegate

- (void)editSetTableViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editSetTableViewControllerDidEditSet:(Set *)set {
    [self uploadSet];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kMatchModePrepareSegue]) {
        MatchPrepareViewController *dvc = segue.destinationViewController;
        MatchOrganizer *matchModeOrganizer = [MatchOrganizer createWithSet:self.set];
        
        dvc.organizer = matchModeOrganizer;
        dvc.cancelBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
        dvc.finishMatchBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
        
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"userId"];
    
    [self.serviceLocator.setService postSet:self.set userId:uid completion:^(NSError *error) {
        
    }];
}

@end
