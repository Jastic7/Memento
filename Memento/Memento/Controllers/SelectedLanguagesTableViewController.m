//
//  SelectedLanguagesTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SelectedLanguagesTableViewController.h"
#import "SelectLanguageTableViewController.h"
#import "ServiceLocator.h"

static NSString * const kSelectLangSegue = @"selectLanguageSegue";


@interface SelectedLanguagesTableViewController ()

@property (nonatomic, assign) BOOL isTermSelected;
@property (nonatomic, assign) BOOL deletedWasTapped;

@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *languages;
@property (nonatomic, strong) ServiceLocator *serviceLocator;

@property (weak, nonatomic) IBOutlet UILabel *termLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLanguageLabel;

@end


@implementation SelectedLanguagesTableViewController

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (NSDictionary <NSString *, NSString *> *)languages {
    if (!_languages) {
        _languages = self.serviceLocator.speechService.codesToLanguages;
    }
    
    return _languages;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLanguageLabels];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.completionWithLanguages(self.termLanguageCode, self.definitionLanguageCode);
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.deletedWasTapped) {
        self.deleteSetCompletion();
    } else {
        self.completionWithLanguages(self.termLanguageCode, self.definitionLanguageCode);
    }
}

#pragma mark - Configure

- (void)configureLanguageLabels {
    NSString *termLang = self.languages[self.termLanguageCode];
    NSString *definitionLang = self.languages[self.definitionLanguageCode];
    
    self.termLanguageLabel.text = termLang == nil ? @"Select language" : termLang;
    self.definitionLanguageLabel.text = definitionLang == nil ? @"Select language" : definitionLang;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.isTermSelected = YES;
        [self performSegueWithIdentifier:kSelectLangSegue sender:self.termLanguageLabel];
    } else if (indexPath.row == 1) {
        self.isTermSelected = NO;
        [self performSegueWithIdentifier:kSelectLangSegue sender:self.definitionLanguageLabel];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UILabel *label = sender;
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kSelectLangSegue]) {
        SelectLanguageTableViewController *dvc = segue.destinationViewController;
        dvc.selectedLanguage = label.text;
        dvc.completionWithLanguage = ^(NSString *selectedLanguageCode) {
            label.text = self.languages[selectedLanguageCode];
            
            if (self.isTermSelected) {
                self.termLanguageCode = selectedLanguageCode;
            } else {
                self.definitionLanguageCode = selectedLanguageCode;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
}


#pragma mark - Actions

- (IBAction)deleteTapped:(id)sender {
    self.deletedWasTapped = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    self.deleteSetCompletion();
}


@end
