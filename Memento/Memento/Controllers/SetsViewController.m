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
#import "AlertPresenterProtocol.h"
#import "Assembly.h"
#import "AppDelegate.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>

static NSString * const kSetCellID          = @"SetTableViewCell";
static NSString * const kCreateNewSetSegue  = @"CreateNewSetSegue";
static NSString * const kDetailSetSegue     = @"ShowDetailSetSegue";
static NSString * const kShowWelcomeSegue   = @"ShowWelcomeSegue";


@interface SetsViewController () <UITableViewDataSource, UITableViewDelegate, EditSetTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) ServiceLocator *serviceLocator;


@property (nonatomic, strong) NSMutableArray <Set *> *sets;
@property (nonatomic, strong) NSMutableArray <NSString *> *deletedSetsId;
@property (nonatomic, strong) NSIndexPath *indexPathOfSelectedSet;
@property (nonatomic, strong) UILabel *emptyStateLabel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

@end


@implementation SetsViewController

#pragma mark - Getters

- (NSMutableArray <Set *> *)sets {
    if (!_sets) {
        _sets = [NSMutableArray array];
        _deletedSetsId = [NSMutableArray array];
    }
    
    return _sets;
}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (UILabel *)emptyStateLabel {
    if (!_emptyStateLabel) {
        _emptyStateLabel = [self configureEmptyStateLabel];
    }
    
    return _emptyStateLabel;
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
    
    [self configureRefreshControl];
    [self configureTableView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.saveChangesBlock = ^() {
        [Assembly assemblyLocalServiceLayer];
        [self.serviceLocator.setService postSetList:self.sets completion:nil];
        [self.serviceLocator.setService deleteSetsWithId:self.deletedSetsId completion:nil];
    };
    
    [self configureReachability];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.refreshControl endRefreshing];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sets.count > 0) {
        [self.emptyStateLabel removeFromSuperview];
    }
    
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = self.tableView.contentOffset.y;
    if (offset < -150) {
        NSString *title = @"Sets are downloading...";
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    }
}


#pragma mark - EditSetTableViewControllerDelegate

- (void)editSetTableViewControllerDidCancelInEditingMode:(EditingMode)editingMode {
    switch (editingMode) {
        case CreateNewSet: {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)editSetTableViewControllerDidEditSet:(Set *)set inEditingMode:(EditingMode)editingMode {
    switch (editingMode) {
        case CreateNewSet: {
            NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.sets insertObject:set atIndex:firstRow.row];
            [self.tableView insertRowsAtIndexPaths:@[firstRow] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self.serviceLocator.setService postSet:set completion:^(NSError *error) {
                if (error) {
                    [self.alertPresenter showError:error title:@"Sets doesn't uploaded" presentingController:self];
                }
            }];
            break;
        }
            
        case EditExistingSet: {
            [self.tableView reloadRowsAtIndexPaths:@[self.indexPathOfSelectedSet] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)editSetTableViewControllerDidDeleteSet:(Set *)set inEditingMode:(EditingMode)editingMode {
    switch (editingMode) {
        case CreateNewSet: {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case EditExistingSet: {
            [self.sets removeObjectAtIndex:self.indexPathOfSelectedSet.row];
            [self.deletedSetsId addObject:set.identifier];
            
            [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[self.indexPathOfSelectedSet]
                                      withRowAnimation:UITableViewRowAnimationNone];
                self.indexPathOfSelectedSet = nil;
                if (self.sets.count == 0) {
                    [self showEmptyStateLabel];
                }
            [self.tableView endUpdates];
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kCreateNewSetSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        EditSetTableViewController *dvc = (EditSetTableViewController *)navController.topViewController;
        dvc.delegate = self;
        
    } else if ([identifier isEqualToString:kDetailSetSegue]) {
        DetailSetTableViewController *dvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        dvc.set = self.sets[indexPath.row];
        dvc.delegate = self;
        
    } else if ([identifier isEqualToString:kShowWelcomeSegue]) {
        WelcomeViewController *dvc = segue.destinationViewController;
        dvc.authenticationCompletion = ^() {
            [self dismissViewControllerAnimated:YES completion:^{
                [self updateSets];
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
        } else {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (self.presentedViewController == nil) {
                    [self updateSets];
                }
            });
        }
    }];
}


#pragma mark - Configuration 

- (void)configureTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10, 0, 0}]) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        self.tableView.backgroundView = self.refreshControl;
    }
}

- (UILabel *)configureEmptyStateLabel {
    UIFont *font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    NSString *emptyStateText = @"Just tap plus button to add first set!";
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize labelSize = [emptyStateText sizeWithAttributes:attributes];
    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGRect labelRect = CGRectMake(xPos, yPos, labelSize.width, labelSize.height);
    
    UILabel *emptyStateLabel = [[UILabel alloc] initWithFrame:labelRect];
    emptyStateLabel.font = font;
    emptyStateLabel.text = emptyStateText;
    emptyStateLabel.textAlignment = NSTextAlignmentCenter;
    emptyStateLabel.textColor = [UIColor grayColor];
    
    return emptyStateLabel;
}

- (void)configureReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [Assembly assemblyLocalServiceLayer];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self updateSets];
            [self registerAuthStateNotification];
        });
        
        
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [Assembly assemblyLocalServiceLayer];
        } else {
            [Assembly assemblyRemoteServiceLayer];
            [self uploadSets];
        }
    }];
}

- (void)configureRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    NSString *title = @"Sets are downloading...";
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    [self.refreshControl addTarget:self action:@selector(downloadSets:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.backgroundColor = [UIColor clearColor];
}

#pragma mark - Updating

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateEmptyStateLabelLayout];
}

- (void)updateEmptyStateLabelLayout {
    CGRect rect = self.emptyStateLabel.frame;
    rect.origin.x = (self.tableView.bounds.size.width - self.emptyStateLabel.frame.size.width ) / 2;
    rect.origin.y = (self.tableView.bounds.size.height - self.emptyStateLabel.frame.size.height) / 2;
    self.emptyStateLabel.frame = rect;
}

- (void)updateSets {
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
    [self.refreshControl layoutIfNeeded];
    [self downloadSets:self.refreshControl];
}


#pragma mark - Private

- (void)downloadSets:(UIRefreshControl *)refreshControl {
    [self.emptyStateLabel removeFromSuperview];
    
    [self.serviceLocator.setService obtainSetListWithCompletion:^(NSMutableArray<Set *> *setList, NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Sets doesn't downloaded" presentingController:self];
        }
        
        NSString *title = @"Pull to download new sets";
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
        
        [self.tableView beginUpdates];
            [refreshControl endRefreshing];
        [self.tableView endUpdates];
        
        if (setList.count == 0) {
            [self showEmptyStateLabel];
        }
        
        for (Set *set in setList) {
            if (![self.sets containsObject:set]) {
                [self.sets addObject:set];
            }
        }
        
        [self.sets sortUsingComparator:^NSComparisonResult(Set *  _Nonnull obj1, Set *  _Nonnull obj2) {
            return [obj2.creationDate compare:obj1.creationDate];
        }];
        
        [self.tableView reloadData];
    }];
}

- (void)uploadSets {
    [self.serviceLocator.setService postSetList:self.sets completion:^(NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Sets doesn't uploaded" presentingController:self];
        }
    }];
}

- (void)showEmptyStateLabel {
    [self updateEmptyStateLabelLayout];
    [self.tableView addSubview:self.emptyStateLabel];
    [self.emptyStateLabel bringSubviewToFront:self.tableView];
    
}

@end
