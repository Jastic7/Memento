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
        
        [self.transort createNewUserWithEmail:email
                                     password:password
                                      success:^(id response) {
                                          [self uploadUserDataWithId:response userName:username profilePhoto:image completion:completion];
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

- (void)logOut {
    [self.transort logOut];
}

- (void)addAuthStateChangeListener:(void (^)(NSString *))listener {
    [self.transort addListenerForAuthStateChange:listener];
}


#pragma mark - private

- (void)handleSuccessLogInWithResponse:(id)response completion:(AuthLogInCompletionBlock)completion {
    NSString *uid = response;
    
    completion(uid, nil);
}

- (void)uploadUserDataWithId:(NSString *)uid userName:(NSString *)username profilePhoto:(NSData *)photoData completion:(AuthSignUpCompletionBlock)completion {
    NSString *storagePath = @"profileImages";
    
    [self.transort uploadData:photoData storagePath:storagePath userId:uid success:^(id response) {
        NSString *databasePath = @"users";
        NSString *imageUrl = response;
        NSDictionary <NSString *, id> *jsonModel = @{
                                                     @"uid": uid,
                                                     @"username": username,
                                                     @"profileImageUrl": imageUrl
                                                     };
        
        [self.transort postData:jsonModel databasePath:databasePath userId:uid success:^(id response) {
            completion(nil);
        } failure:^(NSError *error) {
            completion(error);
        }];
        
    } failure:^(NSError *error) {
        completion(error);
    }];
    
    
}


@end
