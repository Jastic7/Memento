//
//  LogInTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LogInTableViewController.h"
#import "ServiceLocator.h"
#import "Assembly.h"

@interface LogInTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LogInTableViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Assembly assemblyServiceLayer];
    
}


#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate logInViewControllerDidCancelled];
}


- (IBAction)logInButtonTapped:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator.authService logInWithEmail:email password:password completion:^(NSString *uid, NSError *error) {
        if (error) {
            NSString *errorDescription = error.localizedDescription;
            
            [self showAlertWithTitle:@"Log In failed"
                             message:errorDescription
                         actionTitle:@"OK"];
        } else {
            [self.delegate logInViewControllerDidLoggedIn];
        }
    }];
}


#pragma mark - Private

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               actionTitle:(NSString *)actionTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
