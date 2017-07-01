//
//  LocalServiceFactory.m
//  Memento
//
//  Created by Andrey Morozov on 30.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LocalServiceFactory.h"
#import "AuthService.h"
#import "SetService.h"
#import "UserService.h"
#import "SpeechService.h"
#import "UserDefaultsService.h"
#import "LocalTransportLayer.h"

static NSString * const modelName = @"Memento";

@implementation LocalServiceFactory

- (id <AuthServiceProtocol>)createAuthService {
    return [AuthService createWithTrasport:[LocalTransportLayer managerWithModelName:modelName]];
}

- (id <SetServiceProtocol>)createSetService {
    return [SetService createWithTrasport:[LocalTransportLayer managerWithModelName:modelName]];
}

- (id <UserServiceProtocol>)createUserService {
    return [UserService createWithTrasport:[LocalTransportLayer managerWithModelName:modelName]];
}

- (id <SpeechServiceProtocol>)createSpeechService {
    return [SpeechService createWithTrasport:[LocalTransportLayer managerWithModelName:modelName]];
}

- (id <UserDefaultsServiceProtocol>)createUserDefaultsService {
    return [UserDefaultsService createWithTrasport:[LocalTransportLayer managerWithModelName:modelName]];
}

@end
