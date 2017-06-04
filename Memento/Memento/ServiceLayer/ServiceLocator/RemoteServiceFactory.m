//
//  ServiceFactory.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "RemoteServiceFactory.h"
#import "AuthService.h"
#import "SetService.h"
#import "TransportLayer.h"


@implementation RemoteServiceFactory

- (id <AuthServiceProtocol>)createAuthService {
    return [AuthService createWithTrasport:[TransportLayer manager]];
}

- (id<SetServiceProtocol>)createSetService {
    return [SetService createWithTrasport:[TransportLayer manager]];
}

@end
