//
//  AlertFactoryProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 28.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertFactoryProtocol <NSObject>

- (UIAlertController *)createInfoAlertViewControllerWithTitle:(NSString *)title
                                                      message:(NSString *)message
                                                 dismissTitle:(NSString *)dismissTitle
                                                actionHandler:(void (^)(UIAlertAction *action))handler;

- (UIAlertController *)createWaitingAlertViewControllerWithMessage:(NSString *)message;

- (UIAlertController *)createConfirmAlertControllerWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                        textFieldPlaceholder:(NSString *)placeholder
                                                confirmTitle:(NSString *)confirmTitle
                                              confirmHandler:(void (^)(UIAlertAction *action, NSString *confirmedText))handler;

- (UIAlertController *)createSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                                                 title:(NSString *)title
                                               message:(NSString *)message
                                  presentingController:(UIViewController *)presentingController;

@end
