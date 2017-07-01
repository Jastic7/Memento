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

@interface MatchPrepareViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end


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
    [self.organizer reset];
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
    
    childViewController.organizer        = self.organizer;
    childViewController.cancelBlock      = self.cancelBlock;
    childViewController.finishMatchBlock = ^void(NSString *timeResult) {
        self.titleLabel.text = timeResult;
        self.descriptionLabel.text = @"You found all pairs by that time.\n Can better? Try again!";
    };
    
    self.organizer.delegate = childViewController;
    
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    
    childViewController.view.alpha = 0;
}

@end
