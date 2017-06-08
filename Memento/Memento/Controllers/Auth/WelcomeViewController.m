//
//  WelcomeViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpTableViewController.h"
#import "LogInTableViewController.h"
#import "AuthenticationDelegate.h"


static NSString * const kShowSignUpSegue = @"showSignUpSegue";
static NSString * const kShowLogInSegue = @"showLogInSegue";


@interface WelcomeViewController () <AuthenticationDelegate>

@property (nonatomic, strong) UIView *authWaitingView;

@end


@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    UINavigationController *navController = segue.destinationViewController;
    
    if ([identifier isEqualToString:kShowSignUpSegue]) {
        SignUpTableViewController *dvc = (SignUpTableViewController *)navController.topViewController;
        
        dvc.delegate = self;
    } else if ([identifier isEqualToString:kShowLogInSegue]) {
        LogInTableViewController *dvc = (LogInTableViewController *)navController.topViewController;
        
        dvc.delegate = self;
    }
}


#pragma mark - AuthenticationDelegate

- (void)authenticationDidCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)authenticationDidComplete {
    [self dismissViewControllerAnimated:YES completion:^{
        self.authenticationCompletion();
    }];
}

- (void)dealloc {
    NSLog(@"Welcome dealloced");
}

@end
