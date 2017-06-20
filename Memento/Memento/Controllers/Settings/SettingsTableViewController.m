//
//  SettingsTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "EmailSettingTableViewController.h"
#import "PasswordSettingTableViewController.h"
#import "InfoAlertViewController.h"

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

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
        
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    
    return _imagePicker;
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
    
    [self configureProfileImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.user) {
        self.user = [User userFromUserDefaults];
        
        self.emailLabel.text = self.user.email;
        [self downloadUserProfilePhoto];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary <NSString *, id> *)info {
    self.profilePhotoImageView.image = info[UIImagePickerControllerEditedImage];
    [self uploadUserProfilePhoto];
    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kShowEditEmailSegue]) {
        EmailSettingTableViewController *dvc = segue.destinationViewController;
        dvc.editableEmail = self.user.email;
        dvc.editCompletion = ^void(NSString *editedEmail) {
            self.user = nil;
            [self.navigationController popViewControllerAnimated:YES];
        };
    } else if ([identifier isEqualToString:kShowPasswordSettingSegue]) {
        PasswordSettingTableViewController *dvc = segue.destinationViewController;
        dvc.editCompletion = ^void() {
            [self.navigationController popViewControllerAnimated:YES];
        };
    }

}

- (void)showError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;
    
    InfoAlertViewController *errorAlert = [InfoAlertViewController alertControllerWithTitle:@"User updating failed"
                                                                                    message:errorDescription
                                                                               dismissTitle:@"OK" handler:nil];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}


#pragma mark - Private

- (void)downloadUserProfilePhoto {
    [self.activityIndicator startAnimating];
    
    NSURL *profilePhotoUrl = [NSURL URLWithString:self.user.profilePhotoUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholderProfileImage"];
    
    [self.profilePhotoImageView sd_setImageWithURL:profilePhotoUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityIndicator stopAnimating];
    }];
}

- (void)uploadUserProfilePhoto {
    UIImage *profilePhoto       = self.profilePhotoImageView.image;
    NSData  *profilePhotoData   = UIImageJPEGRepresentation(profilePhoto, 0.9);
    
    [self.serviceLocator.userService postProfilePhotoWithData:profilePhotoData uid:self.user.uid completion:^(NSString *url, NSError *error) {
        if (error) {
            [self showError:error];
        }
    }];
}


#pragma mark - Configuration

- (void)configureProfileImageView {
    self.profilePhotoImageView.layer.cornerRadius = 50;
    [self.profilePhotoImageView setClipsToBounds:YES];
}

@end
