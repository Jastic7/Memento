//
//  LogInTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LogInTableViewController.h"

#import "AuthenticationDelegate.h"
#import "ServiceLocator.h"
#import "AlertPresenterProtocol.h"
#import "Assembly.h"


@interface LogInTableViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

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

- (id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    
    return _alertPresenter;
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
    [self.alertPresenter showPreloaderWithMessage:@"Authorization in progress...\n\n" presentingController:self];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self.serviceLocator.authService logInWithEmail:email password:password completion:^(NSString *uid, NSError *error) {
        if (error) {
            [self.alertPresenter hidePreloaderWithCompletion:^{
                [self.alertPresenter showError:error title:@"Authentication failed" presentingController:self];
            }];
        } else {
            [self reloadUserById:uid];
        }
    }];
}


#pragma mark - Private

- (void)reloadUserById:(NSString *)uid {
    [self.serviceLocator.userService reloadUserById:uid completion:^(NSError *error) {
        [self.alertPresenter hidePreloaderWithCompletion:^{
            if (error) {
                [self.alertPresenter showError:error title:@"Authentication failed" presentingController:self];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}

@end
