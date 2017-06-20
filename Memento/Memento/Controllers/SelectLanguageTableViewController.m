//
//  SelectLanguageTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SelectLanguageTableViewController.h"
#import "SelectLanguageTableViewCell.h"
#import "ServiceLocator.h"


static NSString * const kSelectLanguageCellID = @"SelectLanguageTableViewCell";


@interface SelectLanguageTableViewController ()

@property (nonatomic, strong) ServiceLocator *serviceLocator;
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *languages;
@property (nonatomic, copy) NSArray <NSString *> *alphabeticalLanguages;

@end


@implementation SelectLanguageTableViewController

#pragma mark - Getters 

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (NSDictionary <NSString *, NSString *> *)languages {
    if (!_languages) {
        _languages = self.serviceLocator.speechService.languagesToCodes;
    }
    
    return _languages;
}

- (NSArray<NSString *> *)alphabeticalLanguages {
    if (!_alphabeticalLanguages) {
        _alphabeticalLanguages = [self.languages.allKeys
                                  sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return _alphabeticalLanguages;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alphabeticalLanguages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectLanguageCellID
                                                                        forIndexPath:indexPath];
    
    NSString *language = self.alphabeticalLanguages[indexPath.row];
    BOOL isChecked = [self.selectedLanguage isEqualToString:language];
    if (isChecked) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    [cell configureWithLanguage:language];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *language = self.alphabeticalLanguages[indexPath.row];
    self.completionWithLanguage(self.languages[language]);
}


@end
