//
//  TransportLayer.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

typedef void (^SuccessCompletionBlock)(id response);
typedef void (^FailureCompletionBlock)(NSError *error);


@interface TransportLayer : NSObject

+ (instancetype)manager;

- (void)logOut;

- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure;

- (void)authorizeWithEmail:(NSString *)email
                  password:(NSString *)password
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure;

- (void)updateEmail:(NSString *)email
     withCredential:(NSString *)credential
         completion:(FailureCompletionBlock)completion;

- (void)updatePassword:(NSString *)password
            completion:(FailureCompletionBlock)completion;

- (void)addListenerForAuthStateChange:(void(^)(id response))listener;

- (void)obtainDataWithPath:(NSString *)path
                    userId:(NSString *)uid
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure;

- (void)postData:(id)jsonData
    databasePath:(NSString *)path
          userId:(NSString *)uid
         success:(SuccessCompletionBlock)success
         failure:(FailureCompletionBlock)failure;

- (void)uploadData:(NSData   *)data
       storagePath:(NSString *)path
            userId:(NSString *)uid
           success:(SuccessCompletionBlock)success
           failure:(FailureCompletionBlock)failure;

- (NSString *)uniqueId;

@end
