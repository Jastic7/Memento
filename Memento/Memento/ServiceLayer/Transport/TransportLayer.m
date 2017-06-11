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
    [self startNetworkActivity];
    
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [self finishNetworkActivity];
        
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
    [self startNetworkActivity];
    
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [self finishNetworkActivity];
        
        if (user) {
            success(user.uid);
        } else {
            failure(error);
        }
    }];
}


#pragma mark - Updating

- (void)updateEmail:(NSString *)email withCredential:(NSString *)credential completion:(FailureCompletionBlock)completion {
    [self startNetworkActivity];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *oldEmail = user.email;
    
    FIRAuthCredential *authCredential = [FIREmailPasswordAuthProvider credentialWithEmail:oldEmail password:credential];
    
    [user reauthenticateWithCredential:authCredential completion:^(NSError *_Nullable error) {
        if (error) {
            completion(error);
        } else {
            [user updateEmail:email completion:^(NSError * _Nullable error) {
                completion(error);
            }];
        }
    }];
}

- (void)updatePassword:(NSString *)password
           completion:(FailureCompletionBlock)completion {
    [self startNetworkActivity];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRAuthCredential *credential;
    
    [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
        if (error) {
            completion(error);
        } else {
            [user updatePassword:password completion:^(NSError * _Nullable error) {
                completion(error);
            }];
        }
    }];
}

- (void)addListenerForAuthStateChange:(void (^)(id))listener {
    self.authStateChangeHandle = [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            listener(user.uid);
        } else {
            listener(nil);
        }
    }];
}


#pragma mark - Downloading data

- (void)obtainDataWithPath:(NSString *)path
                    userId:(NSString *)uid
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    FIRDatabaseReference *requestRef = [self databasePath:path withUserId:uid];
    
    [requestRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self finishNetworkActivity];
        
        NSDictionary *response = [snapshot exists] ? snapshot.value : nil;
        
        NSLog(@"%@", response);

        success(response);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - Uploading data

- (void)postData:(id)jsonData
    databasePath:(NSString *)path
          userId:(NSString *)uid
         success:(SuccessCompletionBlock)success
         failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    FIRDatabaseReference *requestRef = [self databasePath:path withUserId:uid];
    
    [requestRef setValue:jsonData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        [self finishNetworkActivity];
        
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
    [self startNetworkActivity];
    
    FIRStorageReference *requestRef = [self storagePath:path withUserId:uid];
    
    [requestRef putData:data metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        [self finishNetworkActivity];
        
        if (error) {
            failure(error);
        } else {
            success(metadata.downloadURL.absoluteString);
        }
    }];
}

- (NSString *)uniqueId {
    return [self.rootRefDB childByAutoId].key;
}


#pragma mark - Private

- (FIRDatabaseReference *)databasePath:(NSString *)path withUserId:(NSString *)uid {
    return [[self.rootRefDB child:path] child:uid];
}

- (FIRStorageReference *)storagePath:(NSString *)path withUserId:(NSString *)uid {
    return [[self.rootRefSR child:path] child:[uid stringByAppendingString:@".jpg"]];
}

- (void)startNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

- (void)finishNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

@end
