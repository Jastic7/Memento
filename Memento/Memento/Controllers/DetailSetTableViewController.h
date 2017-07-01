//
//  DetailSetTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Set;


@interface DetailSetTableViewController : UITableViewController

@property (nonatomic, strong) Set *set;
@property (nonatomic, copy) void (^deleteSetCompletion)(Set *deletedSet);
@property (nonatomic, copy) void (^editSetCompletion)();

@end
