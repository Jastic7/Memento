//
//  TestViewController.m
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "TestViewController.h"
#import "EditingTextView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(10, 50, 300, 30);
    EditingTextView *editingTextView = [[EditingTextView alloc] initWithFrame:frame];
    
    [self.view addSubview:editingTextView];
}



@end
