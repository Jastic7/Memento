//
//  SignUpTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "ServiceLocator.h"
#import "Assembly.h"

@interface SignUpTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation SignUpTableViewController


#pragma mark - Getters

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
    }
    
    return _imagePicker;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Assembly assemblyServiceLayer];
    
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

- (IBAction)cancelDidTapped:(id)sender {
    [self.delegate signUpViewControllerDidCancelled];
}

- (IBAction)createAccountButtonTapped:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *email    = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    UIImage  *avatar   = self.profilePictureImageView.image;
    
    NSData *imageData = UIImageJPEGRepresentation(avatar, 0.9);
    
    ServiceLocator *locator = [ServiceLocator shared];
    [locator.authService signUpWithEmail:email password:password username:username profileImage:imageData completion:^(NSError *error) {
        if (error) {
            NSString *errorDescription = error.localizedDescription;
            
            [self showAlertWithTitle:@"Sign up failed"
                             message:errorDescription
                             actionTitle:@"OK"];
        } else {
            [self.delegate signUpViewControllerDidCreatedUserWithEmail:email
                                                              password:password
                                                              username:username
                                                          profilePhoto:avatar];
        }
    }];
}

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


#pragma mark - Private

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   actionTitle:(NSString *)actionTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)configureProfileImageView {
    self.profilePictureImageView.image = [UIImage imageNamed:@"userProfileDefaultImage"];
    self.profilePictureImageView.layer.cornerRadius = 50;
    [self.profilePictureImageView setClipsToBounds:YES];
}


@end
