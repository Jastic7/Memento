//
//  WaitingAlertViewController.m
//  Memento
//
//  Created by Andrey Morozov on 11.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "WaitingAlertViewController.h"

@interface WaitingAlertViewController ()

@end

@implementation WaitingAlertViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
}


#pragma mark - Initialization

+ (instancetype)alertControllerWithMessage:(NSString *)message {
    return [self alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
}


#pragma mark - Configuration

- (void)configure {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGRect rect = activityIndicator.frame;
    rect.origin.y  = 18;
    rect.origin.x += 20;
    
    activityIndicator.frame = rect;
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
}


@end
