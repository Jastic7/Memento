//
//  WelcomeViewController.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WelcomeViewController : UIViewController

/*!
 * @brief Completion block. It is beeing called, when user is authenticated. 
 */
@property (nonatomic, copy) void (^authenticationCompletion)();

@end
