//
//  CreateSetViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "CreateSetViewController.h"
#import "CreationalNewSetDelegate.h"
#import "Set.h"
@interface CreateSetViewController ()

@end

@implementation CreateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    [self.delegate cancelCreationalNewSet];
    self.delegate = nil;
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    Set *set = [Set new];
    set.title = @"Unit 8. Prepositions without translate translate translate translate translate translate translate";
    set.author = @"Jastic7";
    set.count = 123;
    
    [self.delegate saveNewSet:set];
    self.delegate = nil;
}

@end
