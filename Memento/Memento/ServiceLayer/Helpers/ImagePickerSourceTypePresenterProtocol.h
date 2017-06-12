//
//  ImagePickerSourceTypePresenter.h
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImagePickerSourceTypePresenterProtocol <NSObject>

/*!
 * @brief Present action sheet with source types for UIImagePicker
 * @param imagePicker Image picker which is being presented, when source type is choosed.
 * @param presentingController Controller which will show image picker.
 * @param title Title of action sheet with source types.
 * @param message Message in action sheet.
 */
- (void)presentSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                    presentingController:(UIViewController *)presentingController
                                   title:(NSString *)title
                                 message:(NSString *)message;

@end
