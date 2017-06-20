//
//  InfoAlertViewController.m
//  Memento
//
//  Created by Andrey Morozov on 10.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "InfoAlertViewController.h"

@interface InfoAlertViewController ()

@end

@implementation InfoAlertViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                            dismissTitle:(NSString *)dismissTitle
                                 handler:(void (^)(UIAlertAction *action))handler {
    
    InfoAlertViewController *infoAlert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:dismissTitle style:UIAlertActionStyleDefault handler:handler];
    
    [infoAlert addAction:dismissAction];
    
    return infoAlert;
}


@end
