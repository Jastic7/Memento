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
@property (nonatomic, strong, readonly) NSURL    *profilePhotoUrl;
@property (nonatomic, strong, readonly) NSMutableArray <Set *> *setList;

- (instancetype)initWithId:(NSString *)uid name:(NSString *)name profilePhotoUrl:(NSURL *)photoUrl;
+ (instancetype)userWithId:(NSString *)uid name:(NSString *)name profilePhotoUrl:(NSURL *)photoUrl;

- (void)addSetsFromSetList:(NSMutableArray <Set *> *)setList;

@end
