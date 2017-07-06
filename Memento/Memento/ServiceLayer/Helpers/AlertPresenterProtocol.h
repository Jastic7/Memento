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
 * @param error Occured error, which localized description will be shows.
 * @param title Title of occured error.
 * @param presentingController Controller which present alert.
 */
- (void)showError:(NSError *)error title:(NSString *)title presentingController:(UIViewController *)presentingController;

/*!
 * @brief Show alert with information for user.
 * @param message Information which will be shows.
 * @param title Title of the information.
 * @param actionTitle Title of action button.
 * @param handler Handler of occured action when action button pressed.
 * @param presentingController Controller which present alert.
 */
- (void)showInfoMessage:(NSString *)message
                  title:(NSString *)title
            actionTitle:(NSString *)actionTitle
                handler:(void (^)(UIAlertAction *action))handler
   presentingController:(UIViewController *)presentingController;

/*!
 * @brief Show alert with preloader.
 * @param message Preloader message for user about waiting process.
 * @param presentingController Controller which present alert.
 */
- (void)showPreloaderWithMessage:(NSString *)message
            presentingController:(UIViewController *)presentingController;

/*!
 * @brief Hide preloader alert.
 * @param completion Completion block which is called, when preloader is hidden.
 */
- (void)hidePreloaderWithCompletion:(void (^)())completion;

/*!
 * @brief Show alert with confirm input fields and action.
 * @param message Description of confirming process.
 * @param placeholder Placeholder message in the confirming input textfield.
 * @param handler Handler of occured action with confirmed text.
 * @param presentingController Controller which present alert.
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
