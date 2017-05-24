//
//  LearnRoundViewController.m
//  Memento
//
//  Created by Andrey Morozov on 18.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundViewController.h"
#import "LearnProgressStackView.h"
#import "LearnRoundInfoTableViewController.h"
#import "LearnModeOrganizer.h"
#import "Circle.h"


static NSString * const kLearnRoundInfoNavigationControllerID = @"LearnRoundInfoNavigationController";


@interface LearnRoundViewController () <UINavigationBarDelegate, UITextFieldDelegate, LearnModeOrganizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet LearnProgressStackView *learnProgressView;

@end


@implementation LearnRoundViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.delegate = self;
    self.textField.delegate     = self;
    self.organizer.delegate     = self;
    
    [self configureTextField];
    [self registerNotifications];
    [self.organizer setInitialConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma mark - Actions

- (IBAction)cancelTapped:(UIBarButtonItem *)sender {
    self.cancelingBlock();
}


#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *userDefinition = textField.text;
    BOOL isRightDefinition = [self.organizer checkUserDefinition:userDefinition];
    
    // FIXME: Set correct text field state
    self.textField.text = @"DEFINITION ";
    
    if (isRightDefinition) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.learnProgressView setLearnState:Learnt];
        } completion:^(BOOL finished) {
            [self.organizer updateLearningItem];
        }];
    }
    
    return YES;
}


#pragma mark - LearnModeOrganizerDelegate

- (void)finishLearning {
    [self showRoundInfoViewController];
}

- (void)showNewTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress {
    self.textLabel.text = term;
    [self.learnProgressView setLearnState:learnProgress];
}


#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextFieldWithNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextFieldWithNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)updateTextFieldWithNotification:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    
    CGRect keyboardEndFrameScreenCoordinates = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [self.view convertRect:keyboardEndFrameScreenCoordinates toView:self.view.window];
    
    CGFloat yOffset = keyboardEndFrame.size.height;
    
    CGRect currentFrame = self.textField.frame;
    currentFrame.origin.y = self.view.frame.size.height - yOffset - 50;
    [self.textField setFrame:currentFrame];
}


#pragma mark - Configuration

- (void)configureTextField {
    CGFloat xOffset = 16;
    CGFloat width = self.view.bounds.size.width - 2 * xOffset;
    CGRect frame = CGRectMake(xOffset, 400, width, 44);
    
    [self.textField setFrame:frame];
}

- (void)configureRoundInfoViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:kLearnRoundInfoNavigationControllerID];
    LearnRoundInfoTableViewController *childViewController = (LearnRoundInfoTableViewController *)navigationController.topViewController;
    
    childViewController.roundSet = self.organizer.roundSet;
    childViewController.learningSet = self.organizer.learningSet;
    
    childViewController.cancelingBlock = self.cancelingBlock;
    childViewController.prepareForNextRoundBlock = ^void() {
        [self.organizer updateRoundSet];
        [self.textField becomeFirstResponder];
    };
    
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:self];
    
    navigationController.view.alpha = 0;
}


#pragma mark - Views Showing

- (void)showRoundInfoViewController {
    if (self.childViewControllers.count == 0) {
        [self.view endEditing:YES];
        
        [self configureRoundInfoViewController];
        UINavigationController *childViewController = self.childViewControllers[0];
        
        [UIView animateWithDuration:0.3 animations:^{
            childViewController.view.alpha = 1.0;
        }];
    }
}

- (void)dealloc {
    NSLog(@"LEARN ROUND LEFT");
}

@end
