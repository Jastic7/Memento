//
//  User.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSURL *)photoUrl {
    self = [super init];
    
    if (self) {
        _username        = name;
        _email           = email;
        _profilePhotoUrl = photoUrl;
    }
    
    return self;
}

+ (instancetype)userWithName:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSURL *)photoUrl {
    return [[self alloc] initWithName:name email:email profilePhotoUrl:photoUrl];
}

@end
