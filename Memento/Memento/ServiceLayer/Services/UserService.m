//
//  UserService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "UserMapper.h"
#import "ServiceLocator.h"
#import "TransportLayerProtocol.h"

@interface UserService ()

@property (nonatomic, strong) UserMapper *userMapper;
@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end


@implementation UserService


#pragma mark - Getters

- (UserMapper *)userMapper {
    if (!_userMapper) {
        _userMapper = [UserMapper new];
    }
    
    return _userMapper;
}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

#pragma mark - Paths

- (NSString *)storageProfilePhotoPathWithUserId:(NSString *)uid; {
    NSString *storageProfilePhotoPath = [NSString stringWithFormat:@"profileImages/%@", uid];
    
    return storageProfilePhotoPath;
}

- (NSDictionary *)parametersWithUserId:(NSString *)userId dataId:(NSString *)dataId {
    NSString *dataType = @"users";
    
    NSMutableDictionary <NSString *, NSString *> *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:dataType forKey:@"dataType"];
    [parameters setValue:dataId forKey:@"dataId"];
    [parameters setValue:userId forKey:@"ownerId"];
    
    return parameters;
}

#pragma mark - UserServiceProtocol Implementation 

- (void)establishEditedEmail:(NSString *)email
             currentPassword:(NSString *)password
                  completion:(UserServiceCompletionBlock)completion {
    
    [self.transort establishEditedEmail:email
                        currentPassword:password
                                success:^(id response) { [self updateEmail:email uid:response completion:completion]; }
                                failure:^(NSError *error) { completion(error); }
     ];
}

- (void)establishEditedPassword:(NSString *)password
                currentPassword:(NSString *)currentPassword
                confirmPassword:(NSString *)confirmPassword
                     completion:(UserServiceCompletionBlock)completion {
    
    if ([self isPassword:password matchWithConfirmPassword:confirmPassword]) {
        [self.transort establishEditedPassword:password currentPassword:currentPassword completion:completion];
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"New password and confirm password should be equal", nil)};
        NSError *confirmError = [NSError errorWithDomain:@"Memento" code:-7 userInfo:userInfo];
        completion(confirmError);
    }
}

- (void)reloadUserById:(NSString *)uid completion:(UserServiceCompletionBlock)completion {
    NSDictionary *parameters = [self parametersWithUserId:uid dataId:nil];
    [self.transort obtainDataWithParameters:parameters
                                    success:^(id response) {
                                        User *user = [self.userMapper modelFromJsonOfObject:response];
                                        [self.serviceLocator.userDefaultsService saveUser:user];
                
                                        completion(nil);
                                    }
                                    failure:^(NSError *error) { completion(error); }
     ];
}

- (void)postUserWithId:(NSString *)uid
              username:(NSString *)username
                 email:(NSString *)email
      profilePhotoData:(NSData *)photoData
            completion:(UserServiceCompletionBlock)completion {
    
    [self postProfilePhotoWithData:photoData uid:uid completion:^(NSString *url, NSError *error) {
        if (error) {
            completion(error);
        } else {
            User *user = [User userWithId:uid name:username email:email profilePhotoUrl:url];
            [self postUser:user completion:completion];
        }
    }];
}

- (void)postUser:(User *)user completion:(UserServiceCompletionBlock)completion {
    NSDictionary *jsonModel = [self.userMapper jsonFromModel:user];
    NSDictionary *parameters = [self parametersWithUserId:user.uid dataId:nil];
    [self.transort postData:jsonModel parameters:parameters completion:^(NSError *error) {
        if (!error) {
            [self.serviceLocator.userDefaultsService saveUser:user];
        }
        
        completion(error);
    }];
}

- (void)postProfilePhotoWithData:(NSData *)photoData
                             uid:(NSString *)uid
                      completion:(UserServiceUploadCompletionBlock)completion {
    NSString *storageProfilePhotoPath = [self storageProfilePhotoPathWithUserId:uid];
    
    [self.transort uploadData:photoData
                  storagePath:storageProfilePhotoPath
                      success:^(id response) { [self updateProfilePhotoUrl:response uid:uid completion:completion]; }
                      failure:^(NSError *error) { completion(nil, error); }
     ];
}

- (void)postProfilePhotoWithData:(NSData *)photoData completion:(UserServiceUploadCompletionBlock)completion {
    NSString *uid = [self.serviceLocator.userDefaultsService userId];
    [self postProfilePhotoWithData:photoData uid:uid completion:completion];
}


#pragma mark - private

- (void)updateProfilePhotoUrl:(NSString *)url
                          uid:(NSString *)uid
                   completion:(UserServiceUploadCompletionBlock)completion {
    [self.serviceLocator.userDefaultsService updateUserPhotoUrl:url];
    
    NSDictionary *parameters = [self parametersWithUserId:uid dataId:@"profilePhotoUrl"];
    [self.transort postData:url parameters:parameters completion:^(NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            completion(url, nil);
        }
    }];
}

- (void)updateEmail:(NSString *)editedEmail
                uid:(NSString *)uid
         completion:(UserServiceCompletionBlock)completion {
    [self.serviceLocator.userDefaultsService updateUserEmail:editedEmail];
    
    NSDictionary *parameters = [self parametersWithUserId:uid dataId:@"email"];
    [self.transort postData:editedEmail parameters:parameters completion:completion];
}

- (BOOL)isPassword:(NSString *)password matchWithConfirmPassword:(NSString *)confirmPassword {
    return [password isEqualToString:confirmPassword];
}

@end
