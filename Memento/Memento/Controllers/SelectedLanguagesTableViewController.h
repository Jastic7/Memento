//
//  SelectedLanguagesTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedLanguagesTableViewController : UITableViewController

@property (nonatomic, copy) NSString *termLanguageCode;
@property (nonatomic, copy) NSString *definitionLanguageCode;

@property (nonatomic, copy) void (^completionWithLanguages)(NSString *termLang, NSString *definitionLang);

@end
