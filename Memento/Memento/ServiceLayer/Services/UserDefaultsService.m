//
//  UserDefaultsService.m
//  Memento
//
//  Created by Andrey Morozov on 23.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserDefaultsService.h"

static NSString * const kAudioEnabledKey = @"isAudioEnabled";
static NSString * const kUserName = @"userName";

@interface UserDefaultsService ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation UserDefaultsService

#pragma mark - Getters

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}


#pragma mark - UserDefaultsServiceProtocol implementation

- (BOOL)isAudioEnabled {
    NSString *state = [self.userDefaults objectForKey:kAudioEnabledKey];
    
    if (!state || [state isEqualToString:@"NO"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setIsAudioEnabled:(BOOL)isAudioEnabled {
    NSString *state = isAudioEnabled ? @"YES" : @"NO";
    [self.userDefaults setObject:state forKey:kAudioEnabledKey];
}

- (NSString *)userName {
    return [self.userDefaults objectForKey:kUserName];
}






@end
