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

@property (nonatomic, strong) NSMutableArray<Set *> *sets;

@property (nonatomic, copy) NSString *uid;

@end


@implementation SetsViewController

#pragma mark - Getters

- (NSMutableArray<Set *> *)sets {
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

- (NSString *)uid {
    if (!_uid) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _uid = [userDefaults objectForKey:@"userId"];
    }
    
    return _uid;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
//    [self configureRefreshControl];
    
    [Assembly assemblyServiceLayer];
    
    [self.serviceLocator.authService addAuthStateChangeListener:^(NSString *uid) {
        self.uid = uid;
        
        if (!uid) {
            [self performSegueWithIdentifier:kShowWelcomeSegue sender:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self downloadData:nil];
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
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}


#pragma mark - CreateSetTableViewControllerDelegate

- (void)сreateSetTableViewControllerDidCancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createSetTableViewControllerDidCreateSet:(Set *)set {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.sets addObject:set];
    [self.tableView reloadData];
    
    [self uploadData];
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
    [self.serviceLocator.setService obtainSetListForUserId:self.uid
                                                completion:^(NSMutableArray<Set *> *setList, NSError *error) {
//        [refreshControll endRefreshing];
        
        self.sets = setList;
        [self.tableView reloadData];
    }];
}

- (void)uploadData {
    [self.serviceLocator.setService postSetList:self.sets userId:self.uid completion:^(NSError *error) {
        if (error) {
            //TODO:SHOW ERROR.
        }
    }];
}

@end
