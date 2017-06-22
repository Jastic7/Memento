//
//  LearnSettingsTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 23.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnSettingsTableViewController.h"
#import "ServiceLocator.h"

static NSString * const kAudioEnabledKey = @"isAudioEnabled";

@interface LearnSettingsTableViewController ()

@property (nonatomic, strong) ServiceLocator *serviceLocator;
@property (weak, nonatomic) IBOutlet UISwitch *audioEnabledSwitch;

@end

@implementation LearnSettingsTableViewController

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

- (BOOL)isAudioEnabled {
    return self.audioEnabledSwitch.isOn;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.audioEnabledSwitch setOn:[self.serviceLocator.userDefaultsService isAudioEnabled]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.serviceLocator.userDefaultsService setIsAudioEnabled:[self isAudioEnabled]];
}


#pragma mark - Actions

- (IBAction)resetProgressButtonTapped:(id)sender {
}


@end
