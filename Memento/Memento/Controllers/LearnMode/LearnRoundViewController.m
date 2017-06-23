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
#import "OrganizerProtocol.h"
#import "Circle.h"

static NSString * const kLearnRoundInfoNavigationControllerID = @"LearnRoundInfoNavigationController";


@interface LearnRoundViewController () <UINavigationBarDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet LearnProgressStackView *learnProgressView;

@end


@implementation LearnRoundViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.delegate = self;
    self.textField.delegate     = self;
    
    [self configureTextField];
    [self registerNotifications];
    [self.organizer setInitialConfiguration];
    [self showRoundInfoViewController];
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
    [self.organizer checkDefinition:textField.text];
    
    self.textField.text = @"";
    
    return YES;
}


#pragma mark - LearnModeOrganizerDelegate

- (void)learnOrganizerDidFinishedRound:(id<LearnOrganizerProtocol>)learnOrganizer {
    [self showRoundInfoViewController];
}

- (void)learnOrganizer:(id<LearnOrganizerProtocol>)learnOrganizer didUpdatedTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress {
    self.textLabel.text = term;
    [self.learnProgressView setLearnState:learnProgress];
}

- (void)learnOrganizer:(id<LearnOrganizerProtocol>)learnOrganizer didCheckedDefinitionWithLearningState:(LearnState)learnProgress previousState:(LearnState)previousProgress {
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.learnProgressView setLearnState:learnProgress withPreviousState:previousProgress];
    } completion:^(BOOL finished) {
        if (learnProgress != Mistake) {
            [self.organizer selectNextLearningItem];
        }
    }];
}


#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextFieldWithNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextFieldWithNotification:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Updating

- (void)updateTextFieldWithNotification:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    
    CGRect keyboardEndFrameScreenCoordinates = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [self.view convertRect:keyboardEndFrameScreenCoordinates toView:self.view.window];
    
    CGFloat yOffset = keyboardEndFrame.size.height;
    
    CGRect textFieldFrame = self.textField.frame;
    textFieldFrame.origin.y = self.view.frame.size.height - yOffset - 50;
    [self.textField setFrame:textFieldFrame];
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
    
    childViewController.isLearningFinished  = self.organizer.isFinished;
    childViewController.roundSet            = self.organizer.roundSet;
    childViewController.set                 = self.organizer.set;
    
    childViewController.cancelingBlock           = self.cancelingBlock;
    childViewController.resetProgressBlock = ^void() {
        [self.organizer reset];
    };
    
    childViewController.prepareForNextRoundBlock = ^void() {
        if (self.organizer.isFinished) {
            [self.organizer reset];
        }
        
        [self.organizer updateRoundSet];
        [self.textField becomeFirstResponder];
    };
    
    [self configureNavigationController:navigationController];
}

- (void)configureNavigationController:(UINavigationController *)navigationController {
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
