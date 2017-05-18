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

#import "MatchModeDelegate.h"

#import "Set.h"
#import "ItemOfSet.h"

static NSString * const kItemOfSetCellID = @"ItemOfSetTableViewCell";
static NSString * const kMatchModePrepareSegue = @"matchModePrepareSegue";
static NSString * const kRoundLearnModeSegue = @"roundLearnModeSegue";


@interface DetailSetTableViewController () <MatchModeDelegate>

@end

@implementation DetailSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.set.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID forIndexPath:indexPath];
    ItemOfSet *item = self.set[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kMatchModePrepareSegue]) {
        MatchPrepareViewController *dvc = segue.destinationViewController;
        dvc.delegate = self;
        dvc.set = self.set;
    } else if ([identifier isEqualToString:kRoundLearnModeSegue]) {
        LearnRoundViewController *dvc = segue.destinationViewController;
        dvc.learningSet = self.set;
        dvc.cancelingBlock = ^void() {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}


#pragma mark - MatchModeDelegate

-(void)exitMatchMode {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)finishedMatchMode {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
