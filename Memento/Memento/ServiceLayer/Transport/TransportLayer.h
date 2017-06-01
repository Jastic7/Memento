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


@interface TransportLayer : NSObject

+ (instancetype)manager;

- (void)createNewUserWithEmail:(NSString *)email password:(NSString *)password success:(SuccessCompletionBlock)success failure:(FailureCompletionBlock)failure;
- (void)authorizeWithEmail:(NSString *)email password:(NSString *)password success:(SuccessCompletionBlock)success failure:(FailureCompletionBlock)failure;

@end
