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

@property (nonatomic, strong) FIRAuth *auth;
@property (nonatomic, strong) FIRDatabaseReference *rootRefDB;
@property (nonatomic, strong) FIRStorageReference  *rootRefSR;
@property (nonatomic, strong) FIRAuthStateDidChangeListenerHandle authStateChangeHandle;

@end

@implementation TransportLayer


#pragma mark - Getters

- (FIRAuth *)auth {
    if (!_auth) {
        _auth = [FIRAuth auth];
    }
    
    return _auth;
}

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
    [self.auth signOut:nil];
}

- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    [self.auth createUserWithEmail:email
                          password:password
                        completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [self stopNetworkActivity];
        
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
    
    [self.auth signInWithEmail:email
                      password:password
                    completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [self stopNetworkActivity];
        
        if (user) {
            success(user.uid);
        } else {
            failure(error);
        }
    }];
}


#pragma mark - Updating

- (void)establishEditedEmail:(NSString *)email
             currentPassword:(NSString *)password
                     success:(SuccessCompletionBlock)success
                     failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    FIRUser *user = self.auth.currentUser;
    
    [self reauthenticateWithCurrentPassword:password completion:^(NSError *error) {
        if (error) {
            [self stopNetworkActivity];
            failure(error);
        } else {
            [user updateEmail:email completion:^(NSError * _Nullable error) {
                [self stopNetworkActivity];
                if (error) {
                    failure(error);
                } else {
                    success(user.uid);
                }
            }];
        }
    }];
}

- (void)establishEditedPassword:(NSString *)password
                currentPassword:(NSString *)currentPassword
                     completion:(TransportCompletionBlock)completion {
    [self startNetworkActivity];
    
    FIRUser *user = self.auth.currentUser;
    
    [self reauthenticateWithCurrentPassword:currentPassword completion:^(NSError *error) {
        if (error) {
            [self stopNetworkActivity];
            completion(error);
        } else {
            [user updatePassword:password completion:^(NSError * _Nullable error) {
                [self stopNetworkActivity];
                completion(error);
            }];
        }
    }];
}

- (void)addListenerForAuthStateChange:(void (^)(id))listener {
    self.authStateChangeHandle = [self.auth addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            listener(user.uid);
        } else {
            listener(nil);
        }
    }];
}


#pragma mark - Downloading data

- (void)obtainDataWithPath:(NSString *)path
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    FIRDatabaseReference *requestRef = [self databasePath:path];
    
    [requestRef observeSingleEventOfType:FIRDataEventTypeValue
                               withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                   [self stopNetworkActivity];
        
                                   NSDictionary *response = [snapshot exists] ? snapshot.value : nil;
                                   success(response);
                               }
                         withCancelBlock:^(NSError * _Nonnull error) { [self stopNetworkActivity]; failure(error); }
     ];
}


#pragma mark - Uploading data

- (void)postData:(id)jsonData
    databasePath:(NSString *)path
      completion:(TransportCompletionBlock)completion {
    
    [self startNetworkActivity];
    
    FIRDatabaseReference *requestRef = [self databasePath:path];
    
    [requestRef setValue:jsonData
     withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
         [self stopNetworkActivity];
         completion(error);
    }];
}

- (void)uploadData:(NSData *)data
       storagePath:(NSString *)path
           success:(SuccessCompletionBlock)success
           failure:(FailureCompletionBlock)failure {
    [self startNetworkActivity];
    
    FIRStorageReference *requestRef = [self storagePath:path];
    
    [requestRef putData:data metadata:nil
             completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                 [self stopNetworkActivity];
        
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

- (FIRDatabaseReference *)databasePath:(NSString *)path {
    return [self.rootRefDB child:path];
}

- (FIRStorageReference *)storagePath:(NSString *)path {
    return [self.rootRefSR child:[path stringByAppendingString:@".jpg"]];
}

- (void)startNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

- (void)stopNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

- (void)reauthenticateWithCurrentPassword:(NSString *)password completion:(void (^)(NSError *error))completion {
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentEmail = currentUser.email;
    
    FIRAuthCredential *authCredential = [FIREmailPasswordAuthProvider credentialWithEmail:currentEmail password:password];
    
    [currentUser reauthenticateWithCredential:authCredential completion:completion];
}

@end
