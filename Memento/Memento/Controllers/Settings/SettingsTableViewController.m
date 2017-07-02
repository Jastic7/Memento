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

#import "AlertPresenterProtocol.h"
#import "ServiceLocator.h"
#import "User.h"
#import "Assembly.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kShowEditEmailSegue         = @"showEditEmailSegue";
static NSString * const kShowPasswordSettingSegue   = @"showPasswordSettingSegue";


@interface SettingsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

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

- (id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    
    return _alertPresenter;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureProfileImageView];
    [self registerAuthNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.user) {
        self.user = [self.serviceLocator.userDefaultsService user];
        
        self.emailLabel.text = self.user.email;
        [self downloadUserProfilePhoto];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureImagePicker];
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
    [self.alertPresenter showSourceTypesForImagePicker:self.imagePicker title:@"Choose source for your profile image" message:@"" presentingController:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kShowEditEmailSegue]) {
        EmailSettingTableViewController *dvc = segue.destinationViewController;
        dvc.editableEmail = self.user.email;
        dvc.editCompletion = ^void() {
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
    
    [self.serviceLocator.userService postProfilePhotoWithData:profilePhotoData completion:^(NSString *url, NSError *error) {
        if (error) {
            [self.alertPresenter showError:error title:@"User updating failed" presentingController:self];
        }
    }];
}


#pragma mark - Register Notification

- (void)registerAuthNotification {
    [self.serviceLocator.authService addAuthStateChangeListener:^(NSString *uid) {
        if (!uid) {
            self.tabBarController.selectedIndex = 0;
        }
    }];
}


#pragma mark - Configuration

- (void)configureProfileImageView {
    self.profilePhotoImageView.layer.cornerRadius = 50;
    [self.profilePhotoImageView setClipsToBounds:YES];
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

@end
