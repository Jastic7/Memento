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
@property (nonatomic, copy) NSString *imageUrlPath;

@end


@implementation UserService


#pragma mark - Getters

- (NSString *)rootPath {
    if (!_rootPath) {
        _rootPath = @"users";
    }
    
    return _rootPath;
}

- (NSString *)imageUrlPath {
    if (!_imageUrlPath) {
        _imageUrlPath = [self.rootPath stringByAppendingString:@"/profilePhotoUrl"];
        NSLog(@"%@", _imageUrlPath);
    }
    
    return _imageUrlPath;
}

- (UserMapper *)userMapper {
    if (!_userMapper) {
        _userMapper = [UserMapper new];
    }
    
    return _userMapper;
}


#pragma mark - UserServiceProtocol Implementation 

- (void)reloadUserById:(NSString *)uid completion:(UserServiceCompletionBlock)completion {
    if (uid) {
        [self.transort obtainDataWithPath:self.rootPath userId:uid success:^(id response) {
            User *user = [self.userMapper modelFromJsonOfObject:response];
            [self saveUserIntoUserDefaults:user];
            
            completion(nil);
        } failure:^(NSError *error) {
            completion(error);
        }];
    }
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
    
    [self.transort postData:jsonModel databasePath:self.rootPath userId:user.uid success:^(id response) {
        [self saveUserIntoUserDefaults:user];
        
        completion(nil);
    } failure:^(NSError *error) {
        completion(error);
    }];
}

- (void)postProfilePhotoWithData:(NSData *)photoData uid:(NSString *)uid completion:(UserServiceUploadCompletionBlock)completion {
    [self.transort uploadData:photoData storagePath:@"profileImages" userId:uid success:^(id response) {
        [self updateProfilePhotoUrl:response uid:uid completion:completion];
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}


#pragma mark - private

- (void)saveUserIntoUserDefaults:(User *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user.username           forKey:@"userName"];
    [userDefaults setObject:user.email              forKey:@"userEmail"];
    [userDefaults setObject:user.profilePhotoUrl    forKey:@"userPhotoUrl"];
    [userDefaults setObject:user.uid                forKey:@"userId"];
}

- (void)updateProfilePhotoUrl:(NSString *)url uid:(NSString *)uid completion:(UserServiceUploadCompletionBlock)completion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:url    forKey:@"userPhotoUrl"];
    
    NSDictionary *data = @{@"profilePhotoUrl" : url};
    
    [self.transort postData:data databasePath:self.rootPath userId:uid success:^(id response) {
        completion(url, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

@end
