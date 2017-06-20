//
//  SelectLanguageTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SelectLanguageTableViewController.h"
#import "SelectLanguageTableViewCell.h"

static NSString * const kSelectLanguageCellID = @"SelectLanguageTableViewCell";


@interface SelectLanguageTableViewController ()

@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *languages;

@end


@implementation SelectLanguageTableViewController

- (NSDictionary <NSString *, NSString *> *)languages {
    if (!_languages) {
        _languages = @{@"English": @"en-US",
                       @"Russian": @"ru-RU"};
    }
    
    return _languages;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectLanguageCellID
                                                                        forIndexPath:indexPath];
    
    NSString *language = self.languages.allKeys[indexPath.row];
    BOOL isChecked = [self.selectedLanguage isEqualToString:language];
    if (isChecked) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    [cell configureWithLanguage:language];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *language = self.languages.allKeys[indexPath.row];
    self.completionWithLanguage(self.languages[language]);
}


@end
