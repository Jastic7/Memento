//
//  SignUpTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "WaitingAlertViewController.h"
#import "ServiceLocator.h"
#import "AuthenticationDelegate.h"
#import "User.h"


@interface SignUpTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end


@implementation SignUpTableViewController

#pragma mark - Getters

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
    }
    
    return _imagePicker;
}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureProfileImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary <NSString *, id> *)info {
    self.profilePictureImageView.image = info[UIImagePickerControllerEditedImage];

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions

- (IBAction)chooseProfilePhotoTapped:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"Choose photo"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            [self presentViewController:self.imagePicker animated:YES completion:nil];
                                                            
                                                        }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take a photo"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          [self presentViewController:self.imagePicker animated:YES completion:nil];
                                                      }];
    
    [actionSheet addAction:cancel];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:takePhoto];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)cancelDidTapped:(id)sender {
    [self.delegate authenticationDidCancelled];
}

- (IBAction)createAccountButtonTapped:(id)sender {
    [self showWaitingAlertWithMessage:@"Registration in progress..."];
    
    NSString *username = self.usernameTextField.text;
    NSString *email    = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self.serviceLocator.authService signUpWithEmail:email password:password completion:^(NSString *uid, NSError *error) {
        if (error) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self showError:error];
            }];
        } else {
            [self uploadUserProfilePhotoWithUserId:uid completion:^(NSString *url) {
                if (url) {
                    User *user = [User userWithId:uid name:username email:email profilePhotoUrl:url];
                    [self uploadUser:user];
                }
            }];
        }
    }];
}

#pragma mark - Configuration

- (void)configureProfileImageView {
    self.profilePictureImageView.image = [UIImage imageNamed:@"userProfileDefaultImage"];
    self.profilePictureImageView.layer.cornerRadius = 50;
    [self.profilePictureImageView setClipsToBounds:YES];
}


#pragma mark - ShowingAlerts

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   actionTitle:(NSString *)actionTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showWaitingAlertWithMessage:(NSString *)message {
    WaitingAlertViewController *alert = [WaitingAlertViewController alertControllerWithMessage:message
                                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    [self showAlertWithTitle:@"Registration failed"
                     message:errorDescription
                 actionTitle:@"OK"];
}


#pragma mark - Private

- (void)uploadUserProfilePhotoWithUserId:(NSString *)uid completion:(void (^)(NSString *url))completion {
    UIImage  *profileImage = self.profilePictureImageView.image;
    
    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.9);
    
    [self.serviceLocator.userService updateProfilePhotoWithData:imageData uid:uid completion:^(NSString *url, NSError *error) {
        if (error) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self showError:error];
            }];
        }
        
        completion(url);
    }];
}

- (void)uploadUser:(User *)user {
    [self.serviceLocator.userService postUser:user completion:^(User *user, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (error) {
                [self showError:error];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}



@end
