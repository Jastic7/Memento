//
//  AuthService.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//
#import "AuthService.h"
#import "TransportLayer.h"
#import "User.h"
#import "UserMapper.h"


@implementation AuthService

- (BOOL)isCorrectEmail:(NSString *)email password:(NSString *)password {
    //TODO: ADD IMPLEMENTATION
    return YES;
}


#pragma mark - AuthServiceProtocol Implementation

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password completion:(AuthServiceCompletionBlock)completion {
    
    if ([self isCorrectEmail:email password:password]) {
        [self.transort createNewUserWithEmail:email
                                     password:password
                                      success:^(id response) {
                                          completion(response, nil);
                                      }
                                      failure:^(NSError *error) {
                                          completion(nil, error);
                                      }];
    }
}

- (void)logInWithEmail:(NSString *)email password:(NSString *)password completion:(AuthServiceCompletionBlock)completion {
    
    if ([self isCorrectEmail:email password:password]) {
        [self.transort authorizeWithEmail:email
                                 password:password
                                  success:^(id response) {
                                      completion(response, nil);
                                  }
                                  failure:^(NSError *error) {
                                      completion(nil, error);
                                  }];
    }
}

- (void)updateEmail:(NSString *)email
     withCredential:(NSString *)credential
         completion:(AuthServiceUpdateCompletionBlock)completion {
    
    [self.transort updateEmail:email withCredential:credential completion:completion];
}

- (void)updatePassword:(NSString *)password completion:(AuthServiceUpdateCompletionBlock)completion {
    //TODO:ADD CHECKS
    
    [self.transort updatePassword:password completion:completion];
}

- (void)logOut {
    [self removeUserFromUserDefaults];
    [self.transort logOut];
}

- (void)addAuthStateChangeListener:(void (^)(NSString *))listener {
    [self.transort addListenerForAuthStateChange:listener];
}


#pragma mark - Private 

- (void)removeUserFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"userEmail"];
    [userDefaults removeObjectForKey:@"userPhotoUrl"];
    [userDefaults removeObjectForKey:@"userId"];
}

@end
