//
//  UserServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^UserServiceCompletionBlock)(NSError *error);
typedef void (^UserServiceUploadCompletionBlock)(NSString *url, NSError *error);


@protocol UserServiceProtocol <NSObject>

/*!
 * @brief Set new email for current user. And update email of current user in NSUserDefaults.
 * @param email New email.
 * @param password Current password.
 * @param completion Callback which is being called, when email updating
 * successfully completed or error occured.
 */
- (void)establishEditedEmail:(NSString *)email
             currentPassword:(NSString *)password
                  completion:(UserServiceCompletionBlock)completion;

/*!
 * @brief Set new password for current user.
 * @param password New password.
 * @param currentPassword Current password.
 * @param confirmPassword Confirming password.
 * @param completion Callback which is being called, when email updating
 * successfully completed or error occured.
 */
- (void)establishEditedPassword:(NSString *)password
                currentPassword:(NSString *)currentPassword
                confirmPassword:(NSString *)confirmPassword
                     completion:(UserServiceCompletionBlock)completion;

/*!
 * @brief Download data for a particular user from database
 * and reload saved user in NSUserDefaults.
 * @param uid Identifier of the user, who is being downloaded.
 * @param completion Completion block which will be called after user reloading.
 * It may contain error, if reloading was failed. Or nil, if reloading success.
 */
- (void)reloadUserById:(NSString *)uid completion:(UserServiceCompletionBlock)completion;

/*!
 * @brief Upload user's data to the database. And save it into NSUserDefaults.
 * @param uid Identifier of the user, who is being uploaded.
 * @param username Username of the user, who is being uploaded.
 * @param email Email of the user, who is being uploaded.
 * @param photoData Photo data of the user, who is being uploaded.
 * @param completion Completion block is being called, when user is successfully uploaded
 * or error is occured.
 */
- (void)postUserWithId:(NSString *)uid
              username:(NSString *)username
                 email:(NSString *)email
      profilePhotoData:(NSData *)photoData
            completion:(UserServiceCompletionBlock)completion;

/*!
 * @brief Upload profile data of a particular user to the database and save it into NSUserDefaults.
 * @param user Uploading user.
 * @pararm completion Callback which is being called, when user is successfully uploaded
 * or error is occured.
 */
- (void)postUser:(User *)user completion:(UserServiceCompletionBlock)completion;

/*!
 @brief Upload photo data of a particular user to the database. And reload url of profile photo 
 * in NSUserDefaults.
 @param photoData Profile photo of user.
 @param uid Identifier of the user for uploading profile photo.
 @param completion Completion block which is being called, when photo is uploaded to the database
 * or error is occured. It contains url of the uploaded photo, if there is no error.
 */
- (void)postProfilePhotoWithData:(NSData *)photoData
                             uid:(NSString *)uid
                      completion:(UserServiceUploadCompletionBlock)completion;

@end
