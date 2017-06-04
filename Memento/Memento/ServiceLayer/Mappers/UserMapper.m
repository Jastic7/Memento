//
//  UserMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserMapper.h"
#import "User.h"


@implementation UserMapper

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *username = json[@"username"];
    NSString *profilePhotoStringUrl = json[@"profilePhotoUrl"];
    NSString *uid = json[@"uid"];
    
    NSURL *profilePhotoUrl = [NSURL URLWithString:profilePhotoStringUrl];
    
    User *user = [User userWithId:uid name:username profilePhotoUrl:profilePhotoUrl];
    
    return user;
}

- (NSMutableArray<id> *)modelsFromJsonOfListObject:(NSDictionary *)json {
    return nil;
}

@end
