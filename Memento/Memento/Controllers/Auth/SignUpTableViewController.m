//
//  SignUpTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SignUpTableViewController.h"

#import "AlertPresenterProtocol.h"
#import "AuthenticationDelegate.h"
#import "ServiceLocator.h"
#import "User.h"
#import "Assembly.h"


@interface SignUpTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profilePhotoImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end


@implementation SignUpTableViewController

#pragma mark - Getters

//- (UIImagePickerController *)imagePicker {
//    if (!_imagePicker) {
//        _imagePicker = [UIImagePickerController new];
//        
//        _imagePicker.delegate = self;
//        _imagePicker.allowsEditing = YES;
//    }
//    
//    return _imagePicker;
//}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
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

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTextFieldDelegates];
    [self configureProfileImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureImagePicker];
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary <NSString *, id> *)info {
    self.profilePhotoImageView.image = info[UIImagePickerControllerEditedImage];

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.usernameTextField]) {
        [self.emailTextField becomeFirstResponder];
    } else if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self createAccountButtonTapped:nil];
    }
    
    return YES;
}


#pragma mark - Actions

- (IBAction)chooseProfilePhotoTapped:(id)sender {
    [self.alertPresenter showSourceTypesForImagePicker:self.imagePicker
                                                 title:@"Choose source for your profile image"
                                               message:@""
                                  presentingController:self];
}

- (IBAction)cancelDidTapped:(id)sender {
    [self.delegate authenticationDidCancelled];
}

- (IBAction)createAccountButtonTapped:(id)sender {
    [self.alertPresenter showPreloaderWithMessage:@"Registration in progress...\n\n" presentingController:self];
    
    NSString *email    = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirm  = self.confirmPasswordTextField.text;
    
    [self.serviceLocator.authService signUpWithEmail:email password:password confirmPassword:confirm completion:^(NSString *uid, NSError *error) {
        if (error) {
            [self.alertPresenter hidePreloaderWithCompletion:^{
                [self.alertPresenter showError:error title:@"Registration failed" presentingController:self];
            }];
        } else {
            [self uploadUserWithId:uid];
        }
    }];
}


#pragma mark - Configuration

- (void)configureProfileImageView {
    self.profilePhotoImageView.image = [UIImage imageNamed:@"userProfileDefaultImage"];
    self.profilePhotoImageView.layer.cornerRadius = 50;
    [self.profilePhotoImageView setClipsToBounds:YES];
}

- (void)configureTextFieldDelegates {
    self.usernameTextField.delegate         = self;
    self.emailTextField.delegate            = self;
    self.passwordTextField.delegate         = self;
    self.confirmPasswordTextField.delegate  = self;
}

- (void)configureImagePicker {
    if (!self.imagePicker) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            self.imagePicker = [UIImagePickerController new];
            
            self.imagePicker.delegate = self;
            self.imagePicker.allowsEditing = YES;
        });
    }
}


#pragma mark - Private

- (void)uploadUserWithId:(NSString *)uid {
    NSString *username = self.usernameTextField.text;
    NSString *email = self.emailTextField.text;
    
    UIImage *profilePhoto = self.profilePhotoImageView.image;
    NSData *profilePhotoData = UIImageJPEGRepresentation(profilePhoto, 0.9);
    
    [self.serviceLocator.userService postUserWithId:uid username:username email:email profilePhotoData:profilePhotoData completion:^(NSError *error) {
        [self.alertPresenter hidePreloaderWithCompletion:^{
            if (error) {
                [self.alertPresenter showError:error title:@"Registration failed" presentingController:self];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}

@end
