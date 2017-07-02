//
//  AlertPresenterProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 26.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertFactoryProtocol;


@protocol AlertPresenterProtocol <NSObject>

- (void)setAlertFactory:(id <AlertFactoryProtocol>)alertFactory;

/*!
 * @brief Show alert with error representation.
 */
- (void)showError:(NSError *)error title:(NSString *)title presentingController:(UIViewController *)presentingController;

/*!
 * @brief Show alert with information for user.
 */
- (void)showInfoMessage:(NSString *)message
                  title:(NSString *)title
            actionTitle:(NSString *)actionTitle
                handler:(void (^)(UIAlertAction *action))handler
   presentingController:(UIViewController *)presentingController;

/*!
 * @brief Show alert with preloader.
 */
- (void)showPreloaderWithMessage:(NSString *)message
            presentingController:(UIViewController *)presentingController;

/*!
 * @brief Hide preloader alert.
 */
- (void)hidePreloaderWithCompletion:(void (^)())completion;

/*!
 * @brief Show alert with confirm action.
 */
- (void)showConfirmationWithMessage:(NSString *)message
                   inputPlaceholder:(NSString *)placeholder
                     confirmHandler:(void (^)(UIAlertAction *action, NSString *confirmedText))handler
               presentingController:(UIViewController *)presentingController;

/*!
 * @brief Present action sheet with source types for UIImagePicker
 * @param imagePicker Image picker which is being presented, when source type is choosed.
 * @param title Title of action sheet with source types.
 * @param message Message in action sheet.
 * @param presentingController Controller which will show image picker.
 */
- (void)showSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                                title:(NSString *)title
                              message:(NSString *)message
                 presentingController:(UIViewController *)presentingController;

@end
