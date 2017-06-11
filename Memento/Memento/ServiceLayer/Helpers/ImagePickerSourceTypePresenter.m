//
//  ImagePickerSourceTypePresenter.m
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ImagePickerSourceTypePresenter.h"


@interface ImagePickerSourceTypePresenter ()

@end


@implementation ImagePickerSourceTypePresenter


- (void)presentSourceTypesForImagePicker:(UIImagePickerController *)imagePicker
                    presentingController:(UIViewController *)presentingController
                                   title:(NSString *)title
                                 message:(NSString *)message {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *choosePhoto = [self actionWithTitle:@"Photo library" imagePicker:imagePicker presentingController:presentingController source:UIImagePickerControllerSourceTypePhotoLibrary];
    UIAlertAction *takePhoto = [self actionWithTitle:@"Camera" imagePicker:imagePicker presentingController:presentingController source:UIImagePickerControllerSourceTypeCamera];
    
    [actionSheet addAction:cancel];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:takePhoto];
    
    [presentingController presentViewController:actionSheet animated:YES completion:nil];
}

- (UIAlertAction *)actionWithTitle:(NSString *)title
                       imagePicker:(UIImagePickerController *)imagePicker
              presentingController:(UIViewController *)presentingController
                            source:(UIImagePickerControllerSourceType)source {
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      imagePicker.sourceType = source;
                                                      [presentingController presentViewController:imagePicker animated:YES completion:nil];
                                                  }];
    
    return action;
}


@end
