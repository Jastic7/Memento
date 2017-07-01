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
typedef void (^AuthServiceUpdateCompletionBlock)(NSError *error);


@protocol AuthServiceProtocol <NSObject>

/*!
 * @brief Register new user.
 * @param email User's email.
 * @param password User's password.
 * @param confirmPassword Confirmation of user's password.
 * @param completion Callback when registration is successfully finished
 * or occured error.
 */
- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
        confirmPassword:(NSString *)confirmPassword
             completion:(AuthServiceCompletionBlock)completion;

/*!
 * @brief Authenticate existing user.
 * @param email User's email.
 * @param password User's password.
 * @param completion Callback when authentication is successfully finished
 * or occured error.
 */
- (void)logInWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(AuthServiceCompletionBlock)completion;

/*!
 * @brief De-authenticate current user.
 */
- (void)logOut;

/*!
 * @brief Add new listener for authentication changes.
 * @param listener Message receiver about changing authentication user's state.
 */
- (void)addAuthStateChangeListener:(void(^)(NSString *uid))listener;

/*!
 * @brief Configure unique identifier.
 * @return unique identifier.
 */
- (NSString *)configureUnuiqueId;

@end
