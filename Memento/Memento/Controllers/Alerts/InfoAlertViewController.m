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

- (void)viewDidLoad {
    [super viewDidLoad];

}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle {
    
    InfoAlertViewController *infoAlert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:dismissTitle style:UIAlertActionStyleDefault handler:nil];
    
    [infoAlert addAction:dismissAction];
    
    return infoAlert;
}


@end
