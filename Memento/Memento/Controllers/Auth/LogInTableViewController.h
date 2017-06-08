//
//  LogInViewController.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthenticationDelegate;


@interface LogInTableViewController : UITableViewController

@property (nonatomic, weak) id <AuthenticationDelegate> delegate;

@end
