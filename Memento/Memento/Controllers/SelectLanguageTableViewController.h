//
//  SelectLanguageTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLanguageTableViewController : UITableViewController

@property (nonatomic, copy) NSString *selectedLanguage;
@property (nonatomic, copy) void (^completionWithLanguage)(NSString *language);

@end
