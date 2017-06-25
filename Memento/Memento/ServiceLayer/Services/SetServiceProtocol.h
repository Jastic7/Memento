//
//  SetServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;

typedef void (^SetServiceDownloadCompletionBlock)(NSMutableArray <Set *> *setList, NSError *error);
typedef void (^SetServiceUploadCompletionBlock)(NSError *error);


@protocol SetServiceProtocol <NSObject>

/*!
 * @brief Get list of set for a particular user from database.
 * @param uid User's identifier, whose sets are beeing obtained.
 * @param completion Callback which is beeing called, when sets are successfully obtained
 * or error occured.
 */
- (void)obtainSetListForUserId:(NSString *)uid
                    completion:(SetServiceDownloadCompletionBlock)completion;

/*!
 * @brief Get list of set for a current loggined user from database.
 * @param completion Callback which is beeing called, when sets are successfully obtained
 * or error occured.
 */
- (void)obtainSetListWithCompletion:(SetServiceDownloadCompletionBlock)completion;

/*!
 * @brief Post list of set for a particular user to database.
 * @param uid User's identifier, whose sets are beeing posted.
 * @param completion Callback which is beeing called, when sets are successfully posted
 * or error occured.
 */
- (void)postSetList:(NSArray <Set *> *)setList
             userId:(NSString *)uid
         completion:(SetServiceUploadCompletionBlock)completion;

/*!
 * @brief Post list of set for the current loggined user to database.
 * @param completion Callback which is beeing called, when sets are successfully posted
 * or error occured.
 */
- (void)postSetList:(NSArray <Set *> *)setList
         completion:(SetServiceUploadCompletionBlock)completion;

/*!
 * @brief Post set for a particular user to database.
 * @param uid User's identifier, whose set is beeing posted.
 * @param completion Callback which is beeing called, when set is successfully posted
 * or error occured.
 */
- (void)postSet:(Set *)set
         userId:(NSString *)uid
     completion:(SetServiceUploadCompletionBlock)completion;

/*!
 * @brief Post set for the current loggined user to database.
 * @param completion Callback which is beeing called, when set is successfully posted
 * or error occured.
 */
- (void)postSet:(Set *)set
     completion:(SetServiceUploadCompletionBlock)completion;

/*!
 * @brief Configure unique identifier.
 * @return unique identifier.
 */
- (NSString *)configureUnuiqueId;

@end
