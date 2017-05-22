//
//  LearnRoundViewController.m
//  Memento
//
//  Created by Andrey Morozov on 18.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundViewController.h"
#import "LearnRoundInfoTableViewController.h"
#import "Set.h"
#import "ItemOfSet.h"

static NSUInteger const kCountItemsInRound = 7;
static NSString * const kLearnRoundInfoNavigationControllerID = @"LearnRoundInfoNavigationController";


@interface LearnRoundViewController () <UINavigationBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

/*!
 * @brief Contains items for current learning round.
 */
@property (nonatomic, strong) Set *roundSet;
/*!
 * @brief Responsible for tracking number of rounds.
 */
@property (nonatomic, assign) NSUInteger currentRound;
/*!
 * @brief Responsible for tracking position in whole 
 * learning set, which will be using for creating 
 * new subset in the new round.
 */
@property (nonatomic, assign) NSUInteger location;

/*!
 * @brief Responsible for tracking index of learning
 * item from the roundSet.
 */
@property (nonatomic, assign) NSUInteger roundItemIndex;
/*!
 * @brief Current item from roundSet.
 */
@property (nonatomic, strong) ItemOfSet *roundItem;

@property (nonatomic, assign) BOOL isLastRound;

@end


@implementation LearnRoundViewController


#pragma mark - Getters

- (Set *)roundSet {
    if (!_roundSet) {
        _roundSet = [Set new];
    }
    
    return _roundSet;
}


#pragma mark - Setters

- (void)setRoundItemIndex:(NSUInteger)roundItemIndex {
    _roundItemIndex = roundItemIndex;
    
    if (_roundItemIndex == self.roundSet.count) {
        self.currentRound++;
        return;
    }
    
    self.roundItem = self.roundSet[_roundItemIndex];
}

- (void)setRoundItem:(ItemOfSet *)roundItem {
    _roundItem = roundItem;
    self.textLabel.text = _roundItem.term;
}

- (void)setCurrentRound:(NSUInteger)currentRound {
    _currentRound = currentRound;
    [self updateRoundSet];
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.delegate = self;
    self.textField.delegate     = self;
    
    [self configure];
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
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
    if ([userDefinition isEqualToString:self.roundItem.definition]) {
        self.roundItemIndex++;
        textField.text = @"DEFINITION ";
    } else {
        textField.text = @"";
    }
    return YES;
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

- (void)configure {
    CGFloat xOffset = 16;
    CGFloat width = self.view.bounds.size.width - 2 * xOffset;
    CGRect frame = CGRectMake(xOffset, 400, width, 44);
    [self.textField setFrame:frame];

    self.location = 0;
    self.currentRound = 0;
}

- (void)configureRoundInfoViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:kLearnRoundInfoNavigationControllerID];
    LearnRoundInfoTableViewController *childViewController = (LearnRoundInfoTableViewController *)navigationController.topViewController;
    
    childViewController.roundSet = self.roundSet;
    childViewController.cancelingBlock = self.cancelingBlock;
    
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:self];
    
    navigationController.view.alpha = 0;
}

- (void)showRoundInfoViewController {
    if (self.childViewControllers.count == 0) {
        [self configureRoundInfoViewController];
        UINavigationController *childViewController = self.childViewControllers[0];
        
        [UIView animateWithDuration:0.3 animations:^{
            childViewController.view.alpha = 1.0;
        }];
    }
}

- (void)updateRoundSet {
    if (self.isLastRound) {
        [self showRoundInfoViewController];
        return;
    }
    
    //creates the new range for current round.
    self.isLastRound = self.location + kCountItemsInRound >= self.learningSet.count;
    NSUInteger length = self.isLastRound ? self.learningSet.count - self.location : kCountItemsInRound;
    NSRange range = NSMakeRange(self.location, length);
    self.location += length;
    
    //fills round set by new items.
    self.roundSet = [self.learningSet subsetWithRange:range];
    self.roundItemIndex = 0;
    self.roundItem = self.roundSet[self.roundItemIndex];
}

- (void)dealloc {
    NSLog(@"Learn VC LEFT");
}

@end
