//
//  EditSettingTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSettingTableViewController : UITableViewController

@property (nonatomic, copy) NSString *editableSetting;
@property (nonatomic, copy) void (^editCompletion)(NSString *editedSetting);

@end
