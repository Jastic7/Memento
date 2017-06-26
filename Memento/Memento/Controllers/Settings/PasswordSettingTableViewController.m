//
//  PasswordSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "PasswordSettingTableViewController.h"
#import "InfoAlertViewController.h"
#import "ServiceLocator.h"

@interface PasswordSettingTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end


@implementation PasswordSettingTableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    NSString *editedPassword    = self.passwordTextField.text;
    NSString *confirmPassword   = self.confirmPasswordTextField.text;
    NSString *currentPassword    = self.currentPasswordTextField.text;
    
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.userService establishEditedPassword:editedPassword
                                        currentPassword:currentPassword
                                        confirmPassword:confirmPassword
                                             completion:^(NSError *error) {
                                                 if (error) {
                                                     [self showError:error];
                                                 } else {
                                                     self.editCompletion();
                                                 }
                                             }];
}


#pragma mark - Private

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    InfoAlertViewController *infoAlert = [InfoAlertViewController alertControllerWithTitle:@"Updating failed." message:errorDescription dismissTitle:@"OK" handler:nil];
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

@end
