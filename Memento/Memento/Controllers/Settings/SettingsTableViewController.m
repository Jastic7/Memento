//
//  SettingsTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "EditSettingTableViewController.h"
#import "PasswordSettingTableViewController.h"
#import "ImagePickerSourceTypePresenterProtocol.h"
#import "ImagePickerSourceTypePresenter.h"
#import "ServiceLocator.h"
#import "User.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kShowEditEmailSegue         = @"showEditEmailSegue";
static NSString * const kShowPasswordSettingSegue   = @"showPasswordSettingSegue";


@interface SettingsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) id <ImagePickerSourceTypePresenterProtocol> imagePickerSourceTypePresenter;

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end

@implementation SettingsTableViewController

#pragma mark - Getters

- (User *)user {
    if (!_user) {
        _user = [User userFromUserDefaults];
    }
    
    return _user;
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


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePicker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.emailLabel.text = self.user.email;
    
    [self configureProfileImageView];
    [self downloadUserProfilePhoto];
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

- (IBAction)logoutButtonTapped:(id)sender {
    self.user = nil;
    
    [self.serviceLocator.authService logOut];
}

- (IBAction)choosePhotoButtonTapped:(id)sender {
    [self.imagePickerSourceTypePresenter presentSourceTypesForImagePicker:self.imagePicker
                                                     presentingController:self
                                                                    title:@"Choose source for your profile image"
                                                                  message:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSString *title = @"Confirm changes";
        NSString *message = @"You should enter password of your account to make changes";
        UIAlertController *credentialAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *credentials = credentialAlert.textFields[0].text;
            [self performSegueWithIdentifier:kShowEditEmailSegue sender:credentials];
        }];
        
        [credentialAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Enter password";
        }];
        
        [credentialAlert addAction:cancelButton];
        [credentialAlert addAction:confirmButton];
        
        [self presentViewController:credentialAlert animated:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kShowEditEmailSegue]) {
        EditSettingTableViewController *dvc = segue.destinationViewController;
        dvc.editableSetting = self.user.email;
        
        dvc.editCompletion = ^void(NSString *editedEmail) {
            [self.serviceLocator.authService updateEmail:editedEmail withCredential:sender completion:^(NSError *error) {
                if (error) {
                    NSLog(@"UPDATE EMAIL ERROR");
                } else {
                    User *user = [User userWithId:self.user.uid name:self.user.username email:editedEmail profilePhotoUrl:self.user.email];
                    
                    [self updateUser:user];
                }
            }];
        };
        
    } else if ([identifier isEqualToString:kShowPasswordSettingSegue]) {
        
    }
}

- (void)updateUser:(User *)user {
    self.user = user;
    
    [self.serviceLocator.userService postUser:user completion:^(NSError *error) {
        if (error) {
            NSLog(@"ERROR UPDATE USER");
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Private

- (void)downloadUserProfilePhoto {
    [self.activityIndicator startAnimating];
    
    NSURL *imageUrl = [NSURL URLWithString:self.user.profilePhotoUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholderProfileImage"];
    
    [self.profilePhotoImageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Configuration

- (void)configureProfileImageView {
    self.profilePhotoImageView.layer.cornerRadius = 50;
    [self.profilePhotoImageView setClipsToBounds:YES];
}

@end
