//
//  InfoAlertViewController.h
//  Memento
//
//  Created by Andrey Morozov on 10.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoAlertViewController : UIAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                            dismissTitle:(NSString *)dismissTitle
                                 handler:(void (^)(UIAlertAction *action))handler;

@end
