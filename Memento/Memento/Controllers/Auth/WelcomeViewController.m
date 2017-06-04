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

static NSString * const kShowSignUpSegue = @"showSignUpSegue";
static NSString * const kShowLogInSegue = @"showLogInSegue";


@interface WelcomeViewController () <SignUpTableViewControllerDelegate, LogInTableViewControllerDelegate>

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

- (void)logInViewControllerDidLoggedIn {
    [self dismissViewControllerAnimated:YES completion:^{
        [self showWaitingAlertWithTitle:@"" message:@"Authorization in progress..."];
    }];
}


#pragma mark - Private

- (void)showWaitingAlertWithTitle:(NSString *)title
                          message:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGRect rect = activityIndicator.frame;
    rect.origin.y = 19.5;
    rect.origin.x += 20;
    
    activityIndicator.frame = rect;
    [activityIndicator startAnimating];
    
    [alert.view addSubview:activityIndicator];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)dealloc {
    NSLog(@"Welcome dealloced");
}


@end
