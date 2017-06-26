//
//  AlertPresenter.m
//  Memento
//
//  Created by Andrey Morozov on 26.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "AlertPresenter.h"
#import "InfoAlertViewController.h"
#import "WaitingAlertViewController.h"
#import "ConfirmAlertViewController.h"


@interface AlertPresenter ()

@property (nonatomic, weak) WaitingAlertViewController *waitingAlert;

@end


@implementation AlertPresenter

- (void)showError:(NSError *)error title:(NSString *)title presentingController:(UIViewController *)presentingController {
    NSString *errorDescription = error.localizedDescription;
    InfoAlertViewController *infoAlert = [InfoAlertViewController alertControllerWithTitle:title message:errorDescription dismissTitle:@"OK" handler:nil];
    
    [presentingController presentViewController:infoAlert animated:YES completion:nil];
}

- (void)showInfoMessage:(NSString *)message
                 title:(NSString *)title
           actionTitle:(NSString *)actionTitle
               handler:(void (^)(UIAlertAction *))handler
  presentingController:(UIViewController *)presentingController {
    InfoAlertViewController *infoAlert = [InfoAlertViewController alertControllerWithTitle:title message:message dismissTitle:actionTitle handler:handler];
    [presentingController presentViewController:infoAlert animated:YES completion:nil];
}

- (void)showPreloaderWithMessage:(NSString *)message presentingController:(UIViewController *)presentingController {
    WaitingAlertViewController *waitingAlert = [WaitingAlertViewController alertControllerWithMessage:message];
    self.waitingAlert = waitingAlert;
    
    [presentingController presentViewController:waitingAlert animated:YES completion:nil];
}

- (void)hidePreloaderWithCompletion:(void (^)())completion {
    [self.waitingAlert dismissViewControllerAnimated:YES completion:completion];
}

- (void)showConfirmationWithMessage:(NSString *)message
                  inputPlaceholder:(NSString *)placeholder
                          delegate:(id<ConfirmAlertViewControllerDelegate>)delegate
              presentingController:(UIViewController *)presentingController {
    NSString *title = @"Confirmation";
    NSString *confirmTitle = @"Confirm";
    
    ConfirmAlertViewController  *confirmAlert = [ConfirmAlertViewController alertControllerWithTitle:title
                                                                                             message:message
                                                                                textFieldPlaceholder:placeholder
                                                                                        confirmTitle:confirmTitle];
    confirmAlert.delegate = delegate;
    [presentingController presentViewController:confirmAlert animated:YES completion:nil];
}

- (void)showSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                                title:(NSString *)title
                              message:(NSString *)message
                 presentingController:(UIViewController *)presentingController {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"Photo library"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            [presentingController presentViewController:imagePicker animated:YES completion:nil];
                                                        }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                            [presentingController presentViewController:imagePicker animated:YES completion:nil];
                                                        }];
    [actionSheet addAction:cancel];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:takePhoto];
    
    [presentingController presentViewController:actionSheet animated:YES completion:nil];
}

@end
