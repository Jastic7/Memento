//
//  EditSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EmailSettingTableViewController.h"
#import "ConfirmAlertViewController.h"
#import "InfoAlertViewController.h"
#import "ServiceLocator.h"

@interface EmailSettingTableViewController () <ConfirmAlerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) ConfirmAlertViewController *confirmAlert;

@end


@implementation EmailSettingTableViewController

#pragma mark - Getters

- (ConfirmAlertViewController *)confirmAlert {
    if (!_confirmAlert) {
        NSString *title = @"Confirmation";
        NSString *message = @"You should enter your password to save new email. Otherwise, changes will not be saved.";
        NSString *placeholder = @"Enter password";
        NSString *confirm = @"Confirm";
        
        _confirmAlert = [ConfirmAlertViewController alertControllerWithTitle:title
                                                                     message:message
                                                        textFieldPlaceholder:placeholder
                                                                confirmTitle:confirm];
        _confirmAlert.delegate = self;
    }
    
    return _confirmAlert;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = self.editableEmail;
}


#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    [self presentViewController:self.confirmAlert animated:YES completion:nil];
}


#pragma mark - ConfirmAlerViewControllerDelegate

-(void)confirmAlertDidConfirmedWithText:(NSString *)confirmedText {
    [self updateEmail:self.textField.text withPassword:confirmedText];
}


#pragma mark - Private

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    InfoAlertViewController *infoAlert = [InfoAlertViewController alertControllerWithTitle:@"Updating failed." message:errorDescription dismissTitle:@"OK"];
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void)updateEmail:(NSString *)editedEmail withPassword:(NSString *)password {

    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.userService establishEditedEmail:editedEmail currentPassword:password completion:^(NSError *error) {
        
        if (error) {
            [self showError:error];
        } else {
            self.editCompletion(editedEmail);
        }
    }];
}

@end
