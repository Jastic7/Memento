//
//  AuthService.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthServiceProtocol.h"

@class TransportLayer;

@interface AuthService : NSObject<AuthServiceProtocol>

- (instancetype)initWithTrasport:(TransportLayer *)transport;
+ (instancetype)authServiceWithTrasport:(TransportLayer *)transport;

@end
