//
//  User.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "User.h"

@interface User ()

@property (nonatomic, strong) NSMutableArray <Set *> *setList;

@end

@implementation User

- (instancetype)initWithId:(NSString *)uid name:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSString *)photoUrl {
    self = [super init];
    
    if (self) {
        _uid             = uid;
        _username        = name;
        _email           = email;
        _profilePhotoUrl = photoUrl;
    }
    
    return self;
}

+ (instancetype)userWithId:(NSString *)uid name:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSString *)photoUrl {
    return [[self alloc] initWithId:uid name:name email:email profilePhotoUrl:photoUrl];
}

@end
