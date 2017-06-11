//
//  WaitingAlertViewController.h
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingAlertViewController : UIAlertController

+ (instancetype)alertControllerWithMessage:(NSString *)message;

@end
