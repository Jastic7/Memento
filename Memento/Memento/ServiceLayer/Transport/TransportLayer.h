//
//  TransportLayer.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessCompletionBlock)(id response);
typedef void (^FailureCompletionBlock)(NSError *error);

typedef void (^TransportCompletionBlock)(NSError *error);


@interface TransportLayer : NSObject


+ (instancetype)manager;

/*!
 * @brief De-authenticate current user.
 */
- (void)logOut;

/*!
 * @brief Create new account in database and authenticate user.
 * @param email Email of the registrating user.
 * @param password Password of the registrating user.
 * @param success Callback which is being called, when user is successfully registered. 
 * Contains user identifier.
 * @param failure Callback whick is being called, when error is occured.
 */
- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure;

/*!
 * @brief Authenticate user.
 * @param email Email of the authenticating user.
 * @param password Password of the authenticating user.
 * @param success Callback which is being called, when user is successfully authenticated.
 * Contains user identifier.
 * @param failure Callback whick is being called, when error is occured.
 */
- (void)authorizeWithEmail:(NSString *)email
                  password:(NSString *)password
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure;

/*!
 * @brief Set new email for current user.
 * @param email New email.
 * @param password Current password.
 * @param success Callback which is being called, when email is successfully updated.
 * Contains user identifier of current user.
 * @param failure Callback whick is being called, when error is occured.
 */
- (void)establishEditedEmail:(NSString *)email
             currentPassword:(NSString *)password
                     success:(SuccessCompletionBlock)success
                     failure:(FailureCompletionBlock)failure;

/*!
 * @brief Set new password for current user.
 * @param password New password.
 * @param currentPassword Current password.
 * @param completion Callback which is being called, when email is successfully updated
 * or error is occured.
 */
- (void)establishEditedPassword:(NSString *)password
                currentPassword:(NSString *)currentPassword
                     completion:(TransportCompletionBlock)completion;

/*!
 * @brief Add new listener for authentication changes.
 * @param listener Message receiver about changing authentication user's state.
 */
- (void)addListenerForAuthStateChange:(void(^)(id response))listener;

/*!
 * @brief Obtain data from database.
 * @param path Path to the obtaining data.
 * @param success Callback which is being called, when data is successfully obtained.
 * Contains obtained data.
 * @param failure Callback whick is being called, when error is occured.
 */
- (void)obtainDataWithPath:(NSString *)path
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure;

/*!
 * @brief Post data to the database.
 * @param jsonData Posting data.
 * @param path Path to the posting data.
 * @param completion Callback which is being called, when data is successfully posted
 * or error is occured.
 */
- (void)postData:(id)jsonData
    databasePath:(NSString *)path
      completion:(TransportCompletionBlock)completion;

/*!
 * @brief Upload binary data to the storage.
 * @param data Uploading data.
 * @param path Path to the uploading data.
 * @param success Callback which is being called, when data is successfully uploaded.
 * Contains url to the uploaded data.
 * @param failure Callback whick is being called, when error is occured.
 */
- (void)uploadData:(NSData   *)data
       storagePath:(NSString *)path
           success:(SuccessCompletionBlock)success
           failure:(FailureCompletionBlock)failure;

/*!
 * @brief Generate unique identifier.
 * @return unique identifier.
 */
- (NSString *)uniqueId;

@end
