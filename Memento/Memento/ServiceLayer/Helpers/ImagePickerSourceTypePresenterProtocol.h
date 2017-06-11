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

- (void)presentSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                    presentingController:(UIViewController *)presentingController
                                   title:(NSString *)title
                                 message:(NSString *)message;

@end
