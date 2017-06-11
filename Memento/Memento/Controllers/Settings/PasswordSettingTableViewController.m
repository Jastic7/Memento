//
//  PasswordSettingTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "PasswordSettingTableViewController.h"

@interface PasswordSettingTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation PasswordSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveButtonTapped:(id)sender {
}


@end
