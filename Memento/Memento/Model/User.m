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

- (NSMutableArray<Set *> *)setList {
    if (!_setList) {
        _setList = [NSMutableArray array];
    }
    
    return _setList;
}

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

+ (instancetype)userFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username  = [userDefaults objectForKey:@"userName"];
    NSString *email     = [userDefaults objectForKey:@"userEmail"];
    NSString *photoUrl  = [userDefaults objectForKey:@"userPhotoUrl"];
    NSString *uid       = [userDefaults objectForKey:@"userId"];
    
    return [[self alloc] initWithId:uid name:username email:email profilePhotoUrl:photoUrl];
}

- (void)addSetsFromSetList:(NSMutableArray <Set *> *)setList {
    [self.setList addObjectsFromArray:setList];
}

@end
