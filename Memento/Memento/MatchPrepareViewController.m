//
//  MatchPrepareViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchPrepareViewController.h"
#import "MatchItemsCollectionViewController.h"
#import "MatchModeDelegate.h"

static NSString * const kMatchModeStartSegue = @"matchModeStartSegue";

@interface MatchPrepareViewController ()

@end

@implementation MatchPrepareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kMatchModeStartSegue]) {
        MatchItemsCollectionViewController *dvc = segue.destinationViewController;
        dvc.delegate = self.delegate;
        dvc.set = self.set;
    }
}


#pragma mark - Actions

- (IBAction)exitButtonTapped:(UIButton *)sender {
    [self.delegate exitMatchMode];
}

-(void)dealloc {
    NSLog(@"PREPARE MATCH VC LEFT");
}

@end
