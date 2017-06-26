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
@property (nonatomic, strong) UILabel *emptyStateLabel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

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

- (UILabel *)emptyStateLabel {
    if (!_emptyStateLabel) {
        _emptyStateLabel = [self configureEmptyStateLabel];
    }
    
    return _emptyStateLabel;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [self configureRefreshControl];
    }
    
    return _refreshControl;
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
    
    [Assembly assemblyServiceLayer];
    
    [self configureTableView];
    [self registerAuthStateNotification];
    [self configureRefreshControl];
    
    [self.refreshControl beginRefreshing];
    [self downloadSets:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.indexPathOfSelectedSet) {
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPathOfSelectedSet] withRowAnimation:UITableViewRowAnimationFade];
    }
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


#pragma mark - CreateSetTableViewControllerDelegate

- (void)editSetTableViewControllerDidCancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)editSetTableViewControllerDidEditSet:(Set *)set {
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.sets.count inSection:0];
    
    [self.sets addObject:set];
    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self uploadSets];
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
                [self downloadSets:self.refreshControl];
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

- (UIRefreshControl *)configureRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    NSString *title = @"Pull to download new sets";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    [refreshControl addTarget:self action:@selector(downloadSets:) forControlEvents:UIControlEventValueChanged];
    
    return refreshControl;
}


#pragma mark - Private

- (void)downloadSets:(UIRefreshControl *)refreshControl {
    [self.emptyStateLabel removeFromSuperview];
    
    [self.serviceLocator.setService obtainSetListWithCompletion:^(NSMutableArray<Set *> *setList, NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Sets doesn't downloaded" presentingController:self];
        }
        
        [self.tableView beginUpdates];
            [refreshControl endRefreshing];
        [self.tableView endUpdates];
        
        if (setList.count == 0) {
            [self showEmptyStateLabel];
        }
        
        self.sets = setList;
        [self.tableView reloadData];
    }];
}

- (void)uploadSets {
    [self.serviceLocator.setService postSetList:self.sets completion:^(NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"Set doesn't uploaded" presentingController:self];
        }
    }];
}

- (void)showEmptyStateLabel {
    [self updateEmptyStateLabelLayout];
    [self.tableView addSubview:self.emptyStateLabel];
    [self.emptyStateLabel bringSubviewToFront:self.tableView];
    
}

- (void)viewWillLayoutSubviews {
    [self updateEmptyStateLabelLayout];
}

- (void)updateEmptyStateLabelLayout {
    CGRect rect = self.emptyStateLabel.frame;
    rect.origin.x = (self.tableView.bounds.size.width - self.emptyStateLabel.frame.size.width ) / 2;
    rect.origin.y = (self.tableView.bounds.size.height - self.emptyStateLabel.frame.size.height) / 2;
    self.emptyStateLabel.frame = rect;
}

@end
