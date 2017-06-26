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
    NSString *uid               = json[@"uid"];
    NSString *username          = json[@"username"];
    NSString *email             = json[@"email"];
    NSString *profilePhotoUrl   = json[@"profilePhotoUrl"];
    
    return [User userWithId:uid name:username email:email profilePhotoUrl:profilePhotoUrl];
}

- (NSMutableArray<id> *)modelsFromJsonOfListObject:(NSDictionary *)json {
    return nil;
}

- (NSDictionary *)jsonFromModel:(id)model {
    User *user = model;
    
    NSDictionary *json = @{ @"uid"              : user.uid,
                            @"username"         : user.username,
                            @"email"            : user.email,
                            @"profilePhotoUrl"  : user.profilePhotoUrl };
    
    return json;
}


@end
