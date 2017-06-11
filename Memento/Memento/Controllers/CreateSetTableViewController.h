//
//  CreateSetTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Set;

@protocol CreateSetTableViewControllerDelegate <NSObject>

- (void)сreateSetTableViewControllerDidCancel;
- (void)createSetTableViewControllerDidCreateSet:(Set *)set;

@end


@interface CreateSetTableViewController : UITableViewController

@property (nonatomic, weak) id <CreateSetTableViewControllerDelegate> delegate;

@end
