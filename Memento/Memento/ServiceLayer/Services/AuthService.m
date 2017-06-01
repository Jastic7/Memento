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
#import "Firebase.h"

@interface AuthService ()

@property (nonatomic, strong) TransportLayer *transort;

@end


@implementation AuthService

#pragma mark - Initialization

- (instancetype)initWithTrasport:(TransportLayer *)transport {
    self = [super init];
    
    if (self) {
        _transort = transport;
    }
    
    return self;
}

+ (instancetype)authServiceWithTrasport:(TransportLayer *)transport {
    return [[self alloc] initWithTrasport:transport];
}

- (BOOL)isCorrectEmail:(NSString *)email password:(NSString *)password {
    //TODO: ADD IMPLEMENTATION
    return YES;
}


#pragma mark - AuthServiceProtocol Implementation

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password completion:(AuthSignUpCompletionBlock)completion {
    if ([self isCorrectEmail:email password:password]) {
        [self.transort createNewUserWithEmail:email
                                     password:password
                                      success:^(id response) {
                                          completion(response);
                                      }
                                      failure:^(NSError *error) {
                                          completion(error);
                                      }];
    }
}

- (void)logInWithEmail:(NSString *)email password:(NSString *)password completion:(AuthLogInCompletionBlock)completion {
    if ([self isCorrectEmail:email password:password]) {
        [self.transort authorizeWithEmail:email
                                 password:password
                                  success:^(id response) {
                                      [self handleSuccessLogInWithResonse:response completion:completion];
                                  }
                                  failure:^(NSError *error) {
                                      completion(nil, error);
                                  }];
    }
}


#pragma mark - private

- (void)handleSuccessLogInWithResonse:(id)response completion:(AuthLogInCompletionBlock)completion {
    FIRUser *firUser = response;
    User *user = [User new];
    //FIXME: add mapping;
    completion(user, nil);
}



@end
