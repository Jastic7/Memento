//
//  PasswordSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "PasswordSettingTableViewController.h"
#import "ServiceLocator.h"
#import "AlertPresenterProtocol.h"
#import "Assembly.h"

@interface PasswordSettingTableViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *currentPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

@end


@implementation PasswordSettingTableViewController

#pragma mark - Getters 

- (id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    
    return _alertPresenter;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureDelegates];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.currentPasswordTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.currentPasswordTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self saveButtonTapped:nil];
    }
    
    return YES;
}


#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    [self.alertPresenter showPreloaderWithMessage:@"Saving new password...\n\n" presentingController:self];
    
    NSString *editedPassword    = self.passwordTextField.text;
    NSString *confirmPassword   = self.confirmPasswordTextField.text;
    NSString *currentPassword   = self.currentPasswordTextField.text;
    
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.userService establishEditedPassword:editedPassword
                                        currentPassword:currentPassword
                                        confirmPassword:confirmPassword
                                             completion:^(NSError *error) {
                                                 [self.alertPresenter hidePreloaderWithCompletion:^{
                                                     if (error) {
                                                         [self.alertPresenter showError:error title:@"Saving failed" presentingController:self];
                                                     } else {
                                                         self.editCompletion();
                                                     }
                                                 }];
                                             }];
}


#pragma mark - Configure

- (void)configureDelegates {
    self.currentPasswordTextField.delegate = self;
    self.passwordTextField.delegate        = self;
    self.confirmPasswordTextField.delegate = self;
}

@end
