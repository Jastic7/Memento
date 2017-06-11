//
//  EditSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditSettingTableViewController.h"


@interface EditSettingTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation EditSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = self.editableSetting;
}

- (IBAction)saveButtonTapped:(id)sender {
    NSString *editedSetting = self.textField.text;
    
    self.editCompletion(editedSetting);
}


@end
