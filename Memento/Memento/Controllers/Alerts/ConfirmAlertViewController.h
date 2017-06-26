//
//  ConfirmAlertViewController.h
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InfoAlertViewController.h"

@class ConfirmAlertViewController;

@protocol ConfirmAlertViewControllerDelegate <NSObject>

- (void)confirmAlertDidConfirmedWithText:(NSString *)confirmedText;

@end


@interface ConfirmAlertViewController : UIAlertController

@property (nonatomic, weak) id <ConfirmAlertViewControllerDelegate> delegate;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message textFieldPlaceholder:(NSString *)placeholder confirmTitle:(NSString *)confirmTitle;

@end
