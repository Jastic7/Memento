//
//  SignUpTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "WaitingAlertViewController.h"
#import "InfoAlertViewController.h"
#import "ImagePickerSourceTypePresenterProtocol.h"
#import "ImagePickerSourceTypePresenter.h"
#import "ServiceLocator.h"
#import "AuthenticationDelegate.h"
#import "User.h"


@interface SignUpTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profilePhotoImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) id <ImagePickerSourceTypePresenterProtocol> imagePickerSourceTypePresenter;

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

- (id <ImagePickerSourceTypePresenterProtocol>)imagePickerSourceTypePresenter {
    if (!_imagePickerSourceTypePresenter) {
        _imagePickerSourceTypePresenter = [ImagePickerSourceTypePresenter new];
    }
    
    return _imagePickerSourceTypePresenter;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureProfileImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    [self.usernameTextField becomeFirstResponder];
    
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
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


#pragma mark - Actions

- (IBAction)chooseProfilePhotoTapped:(id)sender {
    [self.imagePickerSourceTypePresenter presentSourceTypesForImagePicker:self.imagePicker
                                                     presentingController:self
                                                                    title:@"Choose source for your profile image"
                                                                  message:nil];
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
    self.profilePhotoImageView.image = [UIImage imageNamed:@"userProfileDefaultImage"];
    self.profilePhotoImageView.layer.cornerRadius = 50;
    [self.profilePhotoImageView setClipsToBounds:YES];
}


#pragma mark - ShowingAlerts

- (void)showWaitingAlertWithMessage:(NSString *)message {
    WaitingAlertViewController *alert = [WaitingAlertViewController alertControllerWithMessage:message];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    InfoAlertViewController *errorAlert = [InfoAlertViewController alertControllerWithTitle:@"Registration failed"
                                                                                    message:errorDescription
                                                                               dismissTitle:@"OK"];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}


#pragma mark - Private

- (void)uploadUserProfilePhotoWithUserId:(NSString *)uid completion:(void (^)(NSString *url))completion {
    UIImage  *profileImage = self.profilePhotoImageView.image;
    
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
    [self.serviceLocator.userService postUser:user completion:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (error) {
                [self showError:error];
            } else {
                [self.delegate authenticationDidComplete];
            }
        }];
    }];
}

-(void)dealloc {
    NSLog(@"SIGN UP LEFT");
}

@end
