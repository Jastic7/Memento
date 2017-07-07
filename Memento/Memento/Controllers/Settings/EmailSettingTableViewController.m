//
//  EditSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EmailSettingTableViewController.h"
#import "AlertPresenterProtocol.h"
#import "ServiceLocator.h"
#import "Assembly.h"

@interface EmailSettingTableViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

@end


@implementation EmailSettingTableViewController

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
    [self configureTextField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveButtonTapped:nil];
    return YES;
}


#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    NSString *confirmMessage = @"You should enter your password to save new email. Otherwise, changes will not be saved.";
    NSString *placeholder = @"Enter password";
    
    __weak typeof(self) weakSelf = self;
    [self.alertPresenter showConfirmationWithMessage:confirmMessage
                                    inputPlaceholder:placeholder
                                      confirmHandler:^(UIAlertAction *action, NSString *confirmedText) {
                                          __strong typeof(self) strongWeakSelf = weakSelf;
                                          [strongWeakSelf.alertPresenter showPreloaderWithMessage:@"Saving email...\n\n" presentingController:self];
                                          [strongWeakSelf updateEmail:strongWeakSelf.textField.text withPassword:confirmedText];
                                      }
                                presentingController:self];
}


#pragma mark - Configuration

- (void)configureTextField {
    self.textField.text = self.editableEmail;
    self.textField.delegate = self;
}

#pragma mark - Private

- (void)updateEmail:(NSString *)editedEmail withPassword:(NSString *)password {

    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.userService establishEditedEmail:editedEmail currentPassword:password completion:^(NSError *error) {
        [self.alertPresenter hidePreloaderWithCompletion:^{
            if (error) {
                [self.alertPresenter showError:error title:@"Saving failed" presentingController:self];
            } else {
                self.editCompletion();
            }
        }];
    }];
}

@end
