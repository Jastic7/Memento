//
//  CreateSetTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemOfSet;
@class Set;

@protocol EditSetTableViewControllerDelegate <NSObject>

- (void)editSetTableViewControllerDidCancel;
- (void)editSetTableViewControllerDidEditSet:(Set *)set;

@end


@interface EditSetTableViewController : UITableViewController

@property (nonatomic, weak) id <EditSetTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray <ItemOfSet *> *items;

@end
