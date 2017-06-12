//
//  PasswordSettingTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordSettingTableViewController : UITableViewController

/*!
 * @brief Completion block. It is beeing called, when password 
 * is updated.
 */
@property (nonatomic, copy) void (^editCompletion)();

@end
