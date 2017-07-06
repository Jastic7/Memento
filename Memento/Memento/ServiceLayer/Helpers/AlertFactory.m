//
//  AlertFactory.m
//  Memento
//
//  Created by Andrey Morozov on 28.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "AlertFactory.h"

@implementation AlertFactory

- (UIAlertController *)createInfoAlertViewControllerWithTitle:(NSString *)title
                                                      message:(NSString *)message
                                                 dismissTitle:(NSString *)dismissTitle
                                                actionHandler:(void (^)(UIAlertAction *))handler {
    UIAlertController *infoAlert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:dismissTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:handler];
    [infoAlert addAction:dismissAction];
    
    return infoAlert;
}

- (UIAlertController *)createWaitingAlertViewControllerWithMessage:(NSString *)message {
    UIAlertController *waitingAlert = [UIAlertController alertControllerWithTitle:@""
                                                                          message:message
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.color = [UIColor blackColor];
    indicator.translatesAutoresizingMaskIntoConstraints=NO;
    [waitingAlert.view addSubview:indicator];
    NSDictionary *views = @{@"pending" : waitingAlert.view, @"indicator" : indicator};
    
    NSArray *constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
    NSArray *constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
    NSArray *constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
    
    [waitingAlert.view addConstraints:constraints];
    [indicator setUserInteractionEnabled:NO];
    [indicator startAnimating];
    
    return waitingAlert;
}

- (UIAlertController *)createConfirmAlertControllerWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                        textFieldPlaceholder:(NSString *)placeholder
                                                confirmTitle:(NSString *)confirmTitle
                                              confirmHandler:(void (^)(UIAlertAction *, NSString *confirmedText))handler {
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:title
                                                                          message:message
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    __weak typeof(confirmAlert) weakConfirmAlert = confirmAlert;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(confirmAlert) strongWeakConfirmAlert = weakConfirmAlert;
        
        UITextField *confirmTextField = strongWeakConfirmAlert.textFields[0];
        NSString *confirmedText = confirmTextField.text;
        confirmTextField.text = @"";
        handler(action, confirmedText);
    }];
    
    [confirmAlert addAction:cancelAction];
    [confirmAlert addAction:confirmAction];
    
    [confirmAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.secureTextEntry = YES;
    }];
    
    return confirmAlert;
}

- (UIAlertController *)createSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
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
    
    return actionSheet;
}

@end
