//
//  AuthService.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//
#import "AuthService.h"
#import "TransportLayer.h"
#import "ServiceLocator.h"

@interface AuthService ()

@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end

@implementation AuthService

#pragma mark - Getters

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}


#pragma mark - AuthServiceProtocol Implementation

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(AuthServiceCompletionBlock)completion {
    
    [self.transort createNewUserWithEmail:email
                                 password:password
                                  success:^(id response) { completion(response, nil); }
                                  failure:^(NSError *error) { completion(nil, error); }
     ];
}

- (void)logInWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(AuthServiceCompletionBlock)completion {
    
    [self.transort authorizeWithEmail:email
                             password:password
                              success:^(id response) { completion(response, nil); }
                              failure:^(NSError *error) { completion(nil, error); }
     ];
}

- (void)logOut {
    [self.serviceLocator.userDefaultsService removeUser];
    [self.transort logOut];
}

- (void)addAuthStateChangeListener:(void (^)(NSString *))listener {
    [self.transort addListenerForAuthStateChange:listener];
}


@end
