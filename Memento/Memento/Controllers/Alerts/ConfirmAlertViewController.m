//
//  ConfirmAlertViewController.m
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ConfirmAlertViewController.h"
#import "InfoAlertViewController.h"


@interface ConfirmAlertViewController ()

@end

@implementation ConfirmAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message textFieldPlaceholder:(NSString *)placeholder confirmTitle:(NSString *)confirmTitle {
    
    ConfirmAlertViewController *confirmAlert = [ConfirmAlertViewController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    __weak typeof(confirmAlert) weakConfirmAlert = confirmAlert;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(confirmAlert) strongWeakConfirmAlert = weakConfirmAlert;
        
        UITextField *confirmTextField = strongWeakConfirmAlert.textFields[0];
        [strongWeakConfirmAlert.delegate confirmAlertDidConfirmedWithText:confirmTextField.text];
        confirmTextField.text = @"";
    }];
    
    [confirmAlert addAction:cancelAction];
    [confirmAlert addAction:confirmAction];
    
    [confirmAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.secureTextEntry = YES;
    }];
 
    return confirmAlert;
}


@end
