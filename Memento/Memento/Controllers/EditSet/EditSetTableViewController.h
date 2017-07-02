//
//  CreateSetTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditingMode) {
    CreateNewSet,
    EditExistingSet
};

@class Set;


@protocol EditSetTableViewControllerDelegate <NSObject>

- (void)editSetTableViewControllerDidCancelInEditingMode:(EditingMode)editingMode;
- (void)editSetTableViewControllerDidEditSet:(Set *)set inEditingMode:(EditingMode)editingMode;
- (void)editSetTableViewControllerDidDeleteSet:(Set *)set inEditingMode:(EditingMode)editingMode;

@end


@interface EditSetTableViewController : UITableViewController

@property (nonatomic, weak) id <EditSetTableViewControllerDelegate> delegate;
@property (nonatomic, strong) Set *editableSet;

@end
