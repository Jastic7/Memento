//
//  UserServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^UserServiceCompletionBlock)(User *user, NSError *error);


@protocol UserServiceProtocol <NSObject>

- (void)obtainUserWithId:(NSString *)uid completion:(UserServiceCompletionBlock)completion;

@end
