//
//  EditSettingTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSettingTableViewController : UITableViewController

/*!
 * @brief User's email, which is beeing editing.
 */
@property (nonatomic, copy) NSString *editableEmail;

/*!
 * @brief Completion block with edited email. 
 * It is beeing called, when email is updated.
 */
@property (nonatomic, copy) void (^editCompletion)();

@end
