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
#import "AlertPresenterProtocol.h"
#import "OrganizerProtocol.h"
#import "Circle.h"
#import "Assembly.h"

static NSString * const kLearnRoundInfoNavigationControllerID = @"LearnRoundInfoNavigationController";


@interface LearnRoundViewController () <UINavigationBarDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet LearnProgressStackView *learnProgressView;
@property (nonatomic, weak) IBOutlet UIButton *helpButton;
@property (nonatomic, strong) id <AlertPresenterProtocol> alertPresenter;

@end


@implementation LearnRoundViewController

#pragma mark - Getters

-(id <AlertPresenterProtocol>)alertPresenter {
    if (!_alertPresenter) {
        _alertPresenter = [Assembly assembledAlertPresenter];
    }
    return _alertPresenter;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.delegate = self;
    self.textField.delegate     = self;
    
    [self configureTextField];
    [self configureHelpButton];
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

- (IBAction)helpButtonTapped:(id)sender {
    NSString *answer = [self.organizer getRightAnswer];
    
    [self.alertPresenter showInfoMessage:answer title:@"Right answer" actionTitle:@"OK" handler:nil presentingController:self];
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
    if ([notification.name isEqual:UIKeyboardWillHideNotification]) {
        [self configureTextField];
        [self configureHelpButton];
    } else {
        NSDictionary *info = notification.userInfo;
        
        CGRect keyboardEndFrameScreenCoordinates = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect keyboardEndFrame = [self.view convertRect:keyboardEndFrameScreenCoordinates toView:self.view.window];
        
        CGFloat yOffset = keyboardEndFrame.size.height;
        
        CGRect textFieldFrame = self.textField.frame;
        textFieldFrame.origin.y = self.view.frame.size.height - yOffset - textFieldFrame.size.height - 6;
        [self.textField setFrame:textFieldFrame];
        [self configureHelpButton];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect textFieldRect = self.textField.frame;
    CGFloat xOffset = textFieldRect.origin.x;
    textFieldRect.size.width = self.view.bounds.size.width - 2 * xOffset;
    self.textField.frame = textFieldRect;
    
    [self configureHelpButton];
}


#pragma mark - Configuration

- (void)configureTextField {
    CGFloat xOffset = 16;
    CGFloat yOffset = 16;
    CGFloat width = self.view.bounds.size.width - 2 * xOffset;
    CGFloat height = 44;
    CGFloat yPos = self.view.bounds.size.height - height - yOffset;
    CGRect frame = CGRectMake(xOffset, yPos, width, height);
    
    self.textField.frame = frame;
}

- (void)configureHelpButton {
    [self.helpButton.layer setCornerRadius:3.0];
    CGRect textFieldRect = self.textField.frame;
    CGRect helpRect = self.helpButton.frame;
    helpRect.origin.y = textFieldRect.origin.y - helpRect.size.height - 10;
    CGFloat rightX = CGRectGetMaxX(textFieldRect);
    helpRect.origin.x = rightX - helpRect.size.width;
    self.helpButton.frame = helpRect;
}

- (void)configureRoundInfoViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *childNavigationController = [storyboard instantiateViewControllerWithIdentifier:kLearnRoundInfoNavigationControllerID];
    LearnRoundInfoTableViewController *roundInfoViewController = (LearnRoundInfoTableViewController *)childNavigationController.topViewController;
    
    roundInfoViewController.isLearningFinished  = self.organizer.isFinished;
    roundInfoViewController.roundSet            = self.organizer.roundSet;
    roundInfoViewController.set                 = self.organizer.set;
    
    roundInfoViewController.cancelingBlock      = self.cancelingBlock;
    
    __weak typeof(self)weakSelf = self;
    roundInfoViewController.resetProgressBlock  = ^void() {
        [weakSelf.organizer reset];
    };
    
    roundInfoViewController.prepareForNextRoundBlock = ^void() {
        if (weakSelf.organizer.isFinished) {
            [weakSelf.organizer reset];
        }
        
        [weakSelf.organizer updateRoundSet];
        [weakSelf.textField becomeFirstResponder];
    };
    
    [self configureNavigationController:childNavigationController];
}

- (void)configureNavigationController:(UINavigationController *)childNavigationController {
    [self addChildViewController:childNavigationController];
    [self.view addSubview:childNavigationController.view];
    [childNavigationController didMoveToParentViewController:self];
    
    childNavigationController.view.alpha = 0;
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

@end
