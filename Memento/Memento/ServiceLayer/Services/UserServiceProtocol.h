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
 * @brief Download data for user with @param uid from database
 * and reload saved user in NSUserDefaults.
 * @param uid Identifier of the new user, that will be downloaded.
 * @param completion Completion block which will be called after user reloading.
 * It may contain error, if reloading was failed. Or nil, if reloading success.
 */
- (void)reloadUserById:(NSString *)uid completion:(UserServiceCompletionBlock)completion;


- (void)postUserWithId:(NSString *)uid
              username:(NSString *)username
                 email:(NSString *)email
      profilePhotoData:(NSData *)photoData
            completion:(UserServiceCompletionBlock)completion;

/*!
 * @brief Upload profile data of @param user to the database and save it into NSUserDefaults.
 * @param user Uploading user
 * @pararm completion Completion which will be called after user uploading.
 * It may contain error, if reloading was failed. Or nil, if reloading success.
 */
- (void)postUser:(User *)user completion:(UserServiceCompletionBlock)completion;

/*!
 @brief Upload photo data of the user with @param uid to the database.
 @param uid Identifier of the user for uploading profile photo.
 @param completion Completion block which will be called after photo uploading to the database.
 * It contains url of the uploaded photo, if there is no error.
 */
- (void)postProfilePhotoWithData:(NSData *)photoData
                             uid:(NSString *)uid
                      completion:(UserServiceUploadCompletionBlock)completion;

@end
