//
//  SetsViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SetsViewController.h"
#import "EditSetTableViewController.h"
#import "DetailSetTableViewController.h"
#import "WelcomeViewController.h"

#import "SetTableViewCell.h"

#import "Set.h"
#import "ItemOfSet.h"
#import "ServiceLocator.h"
#import "Assembly.h"
#import "User.h"


@import FirebaseAuth;

static NSString * const kSetCellID          = @"SetTableViewCell";
static NSString * const kCreateNewSetSegue  = @"createNewSetSegue";
static NSString * const kDetailSetSegue     = @"detailSetSegue";
static NSString * const kShowWelcomeSegue   = @"showWelcomeSegue";


@interface SetsViewController () <UITableViewDataSource, UITableViewDelegate, EditSetTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) ServiceLocator *serviceLocator;

@property (nonatomic, strong) NSMutableArray <Set *> *sets;
@property (nonatomic, strong) NSIndexPath *indexPathOfSelectedSet;

@end


@implementation SetsViewController

#pragma mark - Getters

- (NSMutableArray <Set *> *)sets {
    if (!_sets) {
        _sets = [NSMutableArray array];
    }
    
    return _sets;
}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Assembly assemblyServiceLayer];
    
    [self configureTableView];
    [self registerAuthStateNotification];
//    [self configureRefreshControl];
    
    [self downloadData:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.indexPathOfSelectedSet) {
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPathOfSelectedSet] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetCellID forIndexPath:indexPath];
    Set *set = self.sets[indexPath.row];
    [cell configureWithTitle:set.title termsCount:set.count author:set.author];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPathOfSelectedSet = indexPath;
}


#pragma mark - CreateSetTableViewControllerDelegate

- (void)editSetTableViewControllerDidCancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)editSetTableViewControllerDidEditSet:(Set *)set {
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.sets.count inSection:0];
    
    [self.sets addObject:set];
    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self uploadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kCreateNewSetSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        EditSetTableViewController *vc = (EditSetTableViewController *)navController.topViewController;
        vc.delegate = self;
        
    } else if ([identifier isEqualToString:kDetailSetSegue]) {
        DetailSetTableViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        vc.set = self.sets[indexPath.row];
        
    } else if ([identifier isEqualToString:kShowWelcomeSegue]) {
        WelcomeViewController *vc = segue.destinationViewController;
        vc.authenticationCompletion = ^() {
            [self dismissViewControllerAnimated:YES completion:^{
                [self downloadData:nil];
            }];
        };
    }
}


#pragma mark - Register Notification

- (void)registerAuthStateNotification {
    [self.serviceLocator.authService addAuthStateChangeListener:^(NSString *uid) {
        if (!uid) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self performSegueWithIdentifier:kShowWelcomeSegue sender:nil];
            
            [self.sets removeAllObjects];
            [self.tableView reloadData];
            self.indexPathOfSelectedSet = nil;
        }
    }];
}

#pragma mark - Configuration 

- (void)configureTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configureRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    NSString *title = @"Pull to request";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    [refreshControl addTarget:self action:@selector(downloadData:) forControlEvents:UIControlEventAllEvents];
    
    self.tableView.refreshControl = refreshControl;
}


#pragma mark - Private

- (void)downloadData:(UIRefreshControl *)refreshControll {
    [self.serviceLocator.setService obtainSetListWithCompletion:^(NSMutableArray<Set *> *setList, NSError *error) {
//        [refreshControll endRefreshing];
        
        self.sets = setList;
        [self.tableView reloadData];
    }];
}

- (void)uploadData {
    [self.serviceLocator.setService postSetList:self.sets completion:^(NSError *error) {
        if (error) {
            
        }
    }];
}

@end
