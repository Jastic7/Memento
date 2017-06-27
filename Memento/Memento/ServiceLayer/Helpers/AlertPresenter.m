//
//  AlertPresenter.m
//  Memento
//
//  Created by Andrey Morozov on 26.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "AlertPresenter.h"
#import "AlertFactoryProtocol.h"


@interface AlertPresenter ()

@property (nonatomic, strong) id <AlertFactoryProtocol> alertFactory;
@property (nonatomic, weak) UIAlertController *waitingAlert;

@end


@implementation AlertPresenter

- (void)setAlertFactory:(id <AlertFactoryProtocol>)alertFactory {
    _alertFactory = alertFactory;
}

- (void)showError:(NSError *)error title:(NSString *)title presentingController:(UIViewController *)presentingController {
    NSString *errorDescription = error.localizedDescription;
    UIAlertController *errorAlert = [self.alertFactory createInfoAlertViewControllerWithTitle:title message:errorDescription dismissTitle:@"OK" actionHandler:nil];
    
    [presentingController presentViewController:errorAlert animated:YES completion:nil];
}

- (void)showInfoMessage:(NSString *)message
                 title:(NSString *)title
           actionTitle:(NSString *)actionTitle
               handler:(void (^)(UIAlertAction *))handler
  presentingController:(UIViewController *)presentingController {
    UIAlertController *infoAlert = [self.alertFactory createInfoAlertViewControllerWithTitle:title message:message dismissTitle:actionTitle actionHandler:handler];
    
    [presentingController presentViewController:infoAlert animated:YES completion:nil];
}

- (void)showPreloaderWithMessage:(NSString *)message presentingController:(UIViewController *)presentingController {
    UIAlertController *waitingAlert = [self.alertFactory createWaitingAlertViewControllerWithMessage:message];;
    self.waitingAlert = waitingAlert;
    
    [presentingController presentViewController:waitingAlert animated:YES completion:nil];
}

- (void)hidePreloaderWithCompletion:(void (^)())completion {
    [self.waitingAlert dismissViewControllerAnimated:YES completion:completion];
}

- (void)showConfirmationWithMessage:(NSString *)message
                   inputPlaceholder:(NSString *)placeholder
                     confirmHandler:(void (^)(UIAlertAction *action, NSString *confirmedText))handler
               presentingController:(UIViewController *)presentingController {
    NSString *title = @"Confirmation";
    NSString *confirmTitle = @"Confirm";
    
    UIAlertController *confirmAlert = [self.alertFactory createConfirmAlertControllerWithTitle:title
                                                                                       message:message
                                                                          textFieldPlaceholder:placeholder
                                                                                  confirmTitle:confirmTitle
                                                                                confirmHandler:handler];
    
    [presentingController presentViewController:confirmAlert animated:YES completion:nil];
}

- (void)showSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                                title:(NSString *)title
                              message:(NSString *)message
                 presentingController:(UIViewController *)presentingController {
    UIAlertController *actionSheet = [self.alertFactory createSourceTypesForImagePicker:imagePicker title:title message:message presentingController:presentingController];
    
    [presentingController presentViewController:actionSheet animated:YES completion:nil];
}

@end
