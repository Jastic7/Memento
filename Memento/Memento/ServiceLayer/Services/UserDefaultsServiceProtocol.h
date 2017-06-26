//
//  UserDefaultsServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;


@protocol UserDefaultsServiceProtocol <NSObject>

@property (nonatomic, assign) BOOL isAudioEnabled;

- (NSString *)userName;
- (NSString *)userId;

- (void)updateUserPhotoUrl:(NSString *)photoUrl;
- (void)updateUserEmail:(NSString *)email;

- (User *)user;
- (void)saveUser:(User *)user;
- (void)removeUser;

@end
