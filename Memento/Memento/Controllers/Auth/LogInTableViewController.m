//
//  LogInTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LogInTableViewController.h"
#import "WaitingAlertViewController.h"
#import "InfoAlertViewController.h"
#import "ServiceLocator.h"
#import "AuthenticationDelegate.h"


@interface LogInTableViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end

@implementation LogInTableViewController

#pragma mark - Getters

-(ServiceLocator *)serviceLocator {
    if (!_serviceLocator ) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate authenticationDidCancelled];
}


- (IBAction)logInButtonTapped:(id)sender {
    [self showWaitingAlertWithMessage:@"Authorization in progress..."];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self.serviceLocator.authService logInWithEmail:email password:password completion:^(NSString *uid, NSError *error) {
        if (error) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self showError:error];
            }];
        } else {
            [self updateUserById:uid];
        }
    }];
}


#pragma mark - Private

- (void)updateUserById:(NSString *)uid {
    [self.serviceLocator.userService updateUserById:uid completion:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (error) {
                [self showError:error];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}


#pragma mark - Presenting alerts

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    InfoAlertViewController *errorAlert = [InfoAlertViewController alertControllerWithTitle:@"Registration failed"
                                                                                    message:errorDescription
                                                                               dismissTitle:@"OK"];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)showWaitingAlertWithMessage:(NSString *)message {
    
    WaitingAlertViewController *alert = [WaitingAlertViewController alertControllerWithMessage:message];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
