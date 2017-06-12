//
//  User.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Set.h"


@interface User : NSObject

@property (nonatomic, copy, readonly) NSString *uid;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *profilePhotoUrl;

- (instancetype)initWithId:(NSString *)uid name:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSString *)photoUrl;
+ (instancetype)userWithId:(NSString *)uid name:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSString *)photoUrl;
+ (instancetype)userFromUserDefaults;


@end
