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
#import "TransportLayer.h"


@interface UserService ()

@property (nonatomic, strong) UserMapper *userMapper;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation UserService


#pragma mark - Getters

- (UserMapper *)userMapper {
    if (!_userMapper) {
        _userMapper = [UserMapper new];
    }
    
    return _userMapper;
}

- (NSString *)rootPath {
    if (!_rootPath) {
        _rootPath = @"users";
    }
    
    return _rootPath;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

#pragma mark - Paths

- (NSString *)emailPathWithUserId:(NSString *)uid {
    NSString *emailPathFormat = @"%@/%@/email";
    NSString *emailPath = [NSString stringWithFormat:emailPathFormat, self.rootPath, uid];
    
    return emailPath;
}

- (NSString *)profilePhotoUrlPathWithUserId:(NSString *)uid {
    NSString *imageUrlPathFormat = @"%@/%@/profilePhotoUrl";
    NSString *imageUrlPath = [NSString stringWithFormat:imageUrlPathFormat, self.rootPath, uid];
    
    NSLog(@"%@", imageUrlPath);
    
    return imageUrlPath;
}

- (NSString *)userPathWithUserId:(NSString *)uid {
    NSString *userPathFormat = @"%@/%@";
    NSString *userPath = [NSString stringWithFormat:userPathFormat, self.rootPath, uid];
    
    return userPath;
}

- (NSString *)storageProfilePhotoPathWithUserId:(NSString *)uid; {
    NSString *storageProfilePhotoPath = [NSString stringWithFormat:@"profileImages/%@", uid];
    
    return storageProfilePhotoPath;
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
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : NSLocalizedString(@"New password and confirm password should be equal", nil)
                                   };
        NSError *confirmError = [NSError errorWithDomain:@"Memento" code:-7 userInfo:userInfo];
        completion(confirmError);
    }
}

- (void)reloadUserById:(NSString *)uid completion:(UserServiceCompletionBlock)completion {
        NSString *userPath = [self userPathWithUserId:uid];
        
        [self.transort obtainDataWithPath:userPath
                                  success:^(id response) {
                                      User *user = [self.userMapper modelFromJsonOfObject:response];
                                      [self saveUserIntoUserDefaults:user];
                
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
    
    NSString *userPath = [self userPathWithUserId:user.uid];
    
    [self.transort postData:jsonModel databasePath:userPath completion:^(NSError *error) {
        if (!error) {
            [self saveUserIntoUserDefaults:user];
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


#pragma mark - private

- (void)saveUserIntoUserDefaults:(User *)user {
    [self.userDefaults setObject:user.username           forKey:@"userName"];
    [self.userDefaults setObject:user.email              forKey:@"userEmail"];
    [self.userDefaults setObject:user.profilePhotoUrl    forKey:@"userPhotoUrl"];
    [self.userDefaults setObject:user.uid                forKey:@"userId"];
}

- (void)updateProfilePhotoUrl:(NSString *)url
                          uid:(NSString *)uid
                   completion:(UserServiceUploadCompletionBlock)completion {
    [self.userDefaults setObject:url forKey:@"userPhotoUrl"];
    
    NSString *profilePhotoUrlPath = [self profilePhotoUrlPathWithUserId:uid];
    
    [self.transort postData:url databasePath:profilePhotoUrlPath completion:^(NSError *error) {
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
    [self.userDefaults setObject:editedEmail forKey:@"userEmail"];
    
    NSString *emailPath = [self emailPathWithUserId:uid];
    
    [self.transort postData:editedEmail databasePath:emailPath completion:completion];
}

- (BOOL)isPassword:(NSString *)password matchWithConfirmPassword:(NSString *)confirmPassword {
    return [password isEqualToString:confirmPassword];
}

@end
