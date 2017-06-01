//
//  LogInViewController.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol LogInViewControllerDelegate <NSObject>

- (void)logInViewControllerDidCancelled;
- (void)logInViewControllerDidLoggedInWithUser:(User *)user;

@end

@interface LogInViewController : UIViewController

@property (nonatomic, weak) id <LogInViewControllerDelegate> delegate;

@end
