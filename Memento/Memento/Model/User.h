//
//  User.h
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSURL    *profilePhotoUrl;

- (instancetype)initWithName:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSURL *)photoUrl;
+ (instancetype)userWithName:(NSString *)name email:(NSString *)email profilePhotoUrl:(NSURL *)photoUrl;

@end
