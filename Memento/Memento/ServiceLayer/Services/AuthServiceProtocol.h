//
//  AuthServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^AuthServiceCompletionBlock)(NSString *uid, NSError *error);


@protocol AuthServiceProtocol <NSObject>

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(AuthServiceCompletionBlock)completion;

- (void)logInWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(AuthServiceCompletionBlock)completion;

- (void)logOut;

- (void)addAuthStateChangeListener:(void(^)(NSString *uid))listener;

@end
