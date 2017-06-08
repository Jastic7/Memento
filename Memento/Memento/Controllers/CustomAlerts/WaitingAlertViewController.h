//
//  WaitingAlertViewController.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingAlertViewController : UIAlertController

+ (instancetype)alertControllerWithMessage:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
