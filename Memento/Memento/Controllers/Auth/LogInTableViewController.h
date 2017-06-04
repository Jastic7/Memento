//
//  LogInViewController.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol LogInTableViewControllerDelegate <NSObject>

- (void)logInViewControllerDidCancelled;
- (void)logInViewControllerDidLoggedIn;

@end

@interface LogInTableViewController : UITableViewController

@property (nonatomic, weak) id <LogInTableViewControllerDelegate> delegate;

@end
