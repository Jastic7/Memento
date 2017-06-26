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

@interface EmailSettingTableViewController () <ConfirmAlertViewControllerDelegate>

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
    
    self.textField.text = self.editableEmail;
}


#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    NSString *confirmMessage = @"You should enter your password to save new email. Otherwise, changes will not be saved.";
    NSString *placeholder = @"Enter password";
    [self.alertPresenter showConfirmationWithMessage:confirmMessage inputPlaceholder:placeholder delegate:self presentingController:self];
}


#pragma mark - ConfirmAlerViewControllerDelegate

- (void)confirmAlertDidConfirmedWithText:(NSString *)confirmedText {
    [self updateEmail:self.textField.text withPassword:confirmedText];
}


#pragma mark - Private

- (void)updateEmail:(NSString *)editedEmail withPassword:(NSString *)password {

    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.userService establishEditedEmail:editedEmail currentPassword:password completion:^(NSError *error) {
        
        if (error) {
            [self.alertPresenter showError:error title:@"Updating failed" presentingController:self];
        } else {
            self.editCompletion();
        }
    }];
}

@end
