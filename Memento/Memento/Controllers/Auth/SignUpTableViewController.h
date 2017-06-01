//
//  SignUpTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SignUpTableViewControllerDelegate <NSObject>

- (void)signUpViewControllerDidCancelled;
- (void)signUpViewControllerDidCreatedUserWithEmail:(NSString *)email
                                           password:(NSString *)password
                                           username:(NSString *)username
                                       profilePhoto:(UIImage  *)photo;

@end


@interface SignUpTableViewController : UITableViewController

@property (nonatomic, weak) id <SignUpTableViewControllerDelegate> delegate;

@end
