//
//  CreateSetTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Set;

@protocol SaveSetDelegate <NSObject>

-(void)cancelCreationalNewSet;
-(void)saveNewSet:(Set *)set;

@end

@interface CreateSetTableViewController : UITableViewController

@property (nonatomic, weak) id<SaveSetDelegate> delegate;

@end
