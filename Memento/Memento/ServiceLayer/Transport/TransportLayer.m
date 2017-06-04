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
@property (nonatomic, strong) FIRAuthStateDidChangeListenerHandle authStateChangeHandle;

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


#pragma mark - Authentication

- (void)logOut {
    [[FIRAuth auth] signOut:nil];
}

- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure {
    
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            success(user.uid);
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

- (void)addListenerForAuthStateChange:(void (^)(id))listener {
    self.authStateChangeHandle = [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (!user) {
            listener(nil);
        } else {
            listener(user.uid);
        }
    }];
}


#pragma mark - Downloading data

- (void)obtainDataWithPath:(NSString *)path
                    userId:(NSString *)uid
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    
    FIRDatabaseReference *requestRef = [self databasePath:path withUserId:uid];
    
    [requestRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = [snapshot exists] ? snapshot.value : nil;
        
        NSLog(@"%@", response);

        success(response);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - Uploading data

- (void)postData:(NSDictionary *)jsonData
    databasePath:(NSString *)path
          userId:(NSString *)uid
         success:(SuccessCompletionBlock)success
         failure:(FailureCompletionBlock)failure {
    
    FIRDatabaseReference *requestRef = [self databasePath:path withUserId:uid];
    
    [requestRef setValue:jsonData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            failure(error);
        } else {
            success(uid);
        }
    }];
}

- (void)uploadData:(NSData *)data
       storagePath:(NSString *)path
            userId:(NSString *)uid
           success:(SuccessCompletionBlock)success
           failure:(FailureCompletionBlock)failure {
    
    FIRStorageReference *requestRef = [self storagePath:path withUserId:uid];
    
    [requestRef putData:data metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(metadata.downloadURL.absoluteString);
        }
    }];
}


#pragma mark - Private

- (FIRDatabaseReference *)databasePath:(NSString *)path withUserId:(NSString *)uid {
    return [[self.rootRefDB child:path] child:uid];
}

- (FIRStorageReference *)storagePath:(NSString *)path withUserId:(NSString *)uid {
    return [[self.rootRefSR child:path] child:[uid stringByAppendingString:@".jpg"]];
}

@end
