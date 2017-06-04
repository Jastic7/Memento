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

@interface TransportLayer ()

@property (nonatomic, strong) FIRDatabaseReference *rootRefDB;
@property (nonatomic, strong) FIRStorageReference  *rootRefSR;

@end

@implementation TransportLayer


#pragma mark - Getters

- (FIRDatabaseReference *)rootRefDB {
    if (!_rootRefDB) {
        _rootRefDB = [[FIRDatabase database] reference];
    }
    
    return _rootRefDB;
}

- (FIRStorageReference *)rootRefSR {
    if (!_rootRefSR) {
        _rootRefSR = [[FIRStorage storage] reference];
    }
    
    return _rootRefSR;
}


#pragma mark - Singleton

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                  profileImage:(NSData  *)image
                     jsonModel:(NSDictionary *)jsonModel
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure {
    
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            NSString *uid = user.uid;
            
            [[self userWithId:uid] setValue:jsonModel];
            [[self profileImageWithId:uid] putData:image metadata:nil];
            
            success(nil);
        } else {
            failure(error);
        }
    }];
}

- (void)authorizeWithEmail:(NSString *)email
                  password:(NSString *)password
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            success(user.uid);
        } else {
            failure(error);
        }
    }];
}

- (void)obtainSetListWithPath:(NSString *)path
            fromUserWithId:(NSString *)uid
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    
    [[[self userWithId:uid] child:path] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response;
        
        if ([snapshot exists]) {
            response = (NSDictionary <NSString *, id> *)snapshot.value;
            NSLog(@"%@", response);
        }

        success(response);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (FIRDatabaseReference *)userWithId:(NSString *)uid {
    return [[self.rootRefDB child:@"users"] child:uid];
}

- (FIRStorageReference *)profileImageWithId:(NSString *)uid {
    return [[self.rootRefSR child:@"profileImages"] child:uid];
}

@end
