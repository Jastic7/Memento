//
//  UserService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserService.h"
#import "UserMapper.h"
#import "TransportLayer.h"


@implementation UserService

- (void)obtainUserWithId:(NSString *)uid completion:(UserServiceCompletionBlock)completion {
    if (uid) {
        UserMapper *userMapper = [UserMapper new];
        NSString *path = @"users";
        
        [self.transort obtainDataWithPath:path userId:uid success:^(id response) {
            User *user = [userMapper modelFromJsonOfObject:response];
            
            completion(user, nil);
        } failure:^(NSError *error) {
            completion(nil, error);
        }];
    }
}

@end
