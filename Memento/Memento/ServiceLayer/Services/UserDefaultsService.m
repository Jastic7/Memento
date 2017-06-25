//
//  UserDefaultsService.m
//  Memento
//
//  Created by Andrey Morozov on 23.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserDefaultsService.h"
#import "User.h"

static NSString * const kAudioEnabledKey = @"isAudioEnabled";

static NSString * const kUserId = @"userId";
static NSString * const kUserName = @"userName";
static NSString * const kUserEmail = @"userEmail";
static NSString * const kUserPhotoUrl = @"userPhotoUrl";

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

- (NSString *)userId {
    return [self.userDefaults objectForKey:kUserId];
}


- (void)saveUser:(User *)user {
    [self.userDefaults setObject:user.uid                forKey:kUserId];
    [self.userDefaults setObject:user.username           forKey:kUserName];
    [self.userDefaults setObject:user.email              forKey:kUserEmail];
    [self.userDefaults setObject:user.profilePhotoUrl    forKey:kUserPhotoUrl];
    
}

-(void)removeUser {
    [self.userDefaults removeObjectForKey:kUserName];
    [self.userDefaults removeObjectForKey:kUserEmail];
    [self.userDefaults removeObjectForKey:kUserPhotoUrl];
    [self.userDefaults removeObjectForKey:kUserId];
}



@end
