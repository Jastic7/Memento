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

- (instancetype)initWithId:(NSString *)uid name:(NSString *)name profilePhotoUrl:(NSURL *)photoUrl {
    self = [super init];
    
    if (self) {
        _uid             = uid;
        _username        = name;
        _profilePhotoUrl = photoUrl;
    }
    
    return self;
}

+ (instancetype)userWithId:(NSString *)uid name:(NSString *)name profilePhotoUrl:(NSURL *)photoUrl {
    return [[self alloc] initWithId:uid name:name profilePhotoUrl:photoUrl];
}

- (void)addSetsFromSetList:(NSMutableArray <Set *> *)setList {
    [self.setList addObjectsFromArray:setList];
}

@end
