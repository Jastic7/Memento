//
//  MatchPrepareViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchPrepareViewController.h"
#import "MatchItemsCollectionViewController.h"

static NSString * const kMatchModeViewControllerID = @"MatchModeViewController";


@implementation MatchPrepareViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Actions

- (IBAction)exitButtonTapped:(UIButton *)sender {
    self.cancelBlock();
}

- (IBAction)startButtonTapped:(UIButton *)sender {
    if (self.childViewControllers.count == 0) {
        [self configureMatchModeViewController];
        MatchItemsCollectionViewController *childViewController = self.childViewControllers[0];
        [UIView animateWithDuration:0.3 animations:^{
            childViewController.view.alpha = 1.0;
        }];
    }
}


#pragma mark - Configuration

- (void)configureMatchModeViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MatchItemsCollectionViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:kMatchModeViewControllerID];
    
    childViewController.cancelBlock = self.cancelBlock;
    childViewController.finishMatchBlock = self.finishMatchBlock;
    childViewController.organizer   = self.organizer;
    
    self.organizer.delegate = childViewController;
    
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    
    childViewController.view.alpha = 0;
}

- (void)dealloc {
    NSLog(@"PREPARE MATCH VC LEFT");
}

@end
