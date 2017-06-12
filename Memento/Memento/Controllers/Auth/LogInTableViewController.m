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

#import "AuthenticationDelegate.h"
#import "ServiceLocator.h"


@interface LogInTableViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end


@implementation LogInTableViewController

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator ) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - LifeCycle

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
            [self hideWaitingAlertAnimated:YES completion:^{
                [self showInfoAlertWithError:error];
            }];
        } else {
            [self reloadUserById:uid];
        }
    }];
}


#pragma mark - Private

- (void)reloadUserById:(NSString *)uid {
    [self.serviceLocator.userService reloadUserById:uid completion:^(NSError *error) {
        [self hideWaitingAlertAnimated:YES completion:^{
            if (error) {
                [self showInfoAlertWithError:error];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}


#pragma mark - Alerts

- (void)showInfoAlertWithError:(NSError *)error {
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

- (void)hideWaitingAlertAnimated:(BOOL)animated completion:(void (^)())completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
