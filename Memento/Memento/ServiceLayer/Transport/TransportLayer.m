//
//  TransportLayer.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "TransportLayer.h"
#import "Firebase.h"

static TransportLayer *sharedInstance = nil;

@implementation TransportLayer

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)createNewUserWithEmail:(NSString *)email password:(NSString *)password success:(SuccessCompletionBlock)success failure:(FailureCompletionBlock)failure {
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            success(nil);
        } else {
            failure(error);
        }
    }];
}

- (void)authorizeWithEmail:(NSString *)email password:(NSString *)password success:(SuccessCompletionBlock)success failure:(FailureCompletionBlock)failure {
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            success(user);
        } else {
            failure(error);
        }
    }];
}

@end
