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


@implementation AuthService

- (BOOL)isCorrectEmail:(NSString *)email password:(NSString *)password {
    //TODO: ADD IMPLEMENTATION
    return YES;
}


#pragma mark - AuthServiceProtocol Implementation

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
               username:(NSString *)username
           profileImage:(NSData   *)image
             completion:(AuthSignUpCompletionBlock)completion {
    

    
    if ([self isCorrectEmail:email password:password]) {
        NSMutableDictionary <NSString *, id> *jsonModel = [NSMutableDictionary dictionary];
        
        jsonModel[@"username"] = username;
        jsonModel[@"setList"] = @{};
        jsonModel[@"setCount"] = @0;
        
        [self.transort createNewUserWithEmail:email
                                     password:password
                                 profileImage:image
                                    jsonModel:jsonModel
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
                                      [self handleSuccessLogInWithResponse:response completion:completion];
                                  }
                                  failure:^(NSError *error) {
                                      completion(nil, error);
                                  }];
    }
}


#pragma mark - private

- (void)handleSuccessLogInWithResponse:(id)response completion:(AuthLogInCompletionBlock)completion {
    NSString *uid = response;
    
    completion(uid, nil);
}



@end
