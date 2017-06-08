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

- (void)logOut {
    [self.transort logOut];
}

- (void)addAuthStateChangeListener:(void (^)(NSString *))listener {
    [self.transort addListenerForAuthStateChange:listener];
}

@end
