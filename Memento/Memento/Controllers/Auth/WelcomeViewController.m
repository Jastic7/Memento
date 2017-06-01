//
//  WelcomeViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpTableViewController.h"
#import "LogInViewController.h"

@interface WelcomeViewController () <SignUpTableViewControllerDelegate, LogInViewControllerDelegate>

@end


@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"showSignUpSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        SignUpTableViewController *dvc = (SignUpTableViewController *)navController.topViewController;
        
        dvc.delegate = self;
    } else if ([identifier isEqualToString:@"showLogInSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        LogInViewController *dvc = (LogInViewController *)navController.topViewController;
        
        dvc.delegate = self;
    }
}


#pragma mark - SignUpTableViewControllerDelegate

- (void)signUpViewControllerDidCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCreatedUserWithEmail:(NSString *)email password:(NSString *)password username:(NSString *)username profilePhoto:(NSURL *)photo {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"User created!");
    }];
    
}


#pragma mark - LogInViewControllerDelegate

- (void)logInViewControllerDidCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidLoggedInWithUser:(User *)user {
    //TODO::ADD IMPLEMENTATION
}



@end
