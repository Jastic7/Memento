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
#import "CoreDataManager.h"


@implementation LocalServiceFactory

- (id <AuthServiceProtocol>)createAuthService {
    return [AuthService createWithTrasport:[LocalTransportLayer managerWithCoreDataManager:[CoreDataManager manager]]];
}

- (id <SetServiceProtocol>)createSetService {
    return [SetService createWithTrasport:[LocalTransportLayer managerWithCoreDataManager:[CoreDataManager manager]]];
}

- (id <UserServiceProtocol>)createUserService {
    return [UserService createWithTrasport:[LocalTransportLayer managerWithCoreDataManager:[CoreDataManager manager]]];
}

- (id <SpeechServiceProtocol>)createSpeechService {
    return [SpeechService createWithTrasport:[LocalTransportLayer managerWithCoreDataManager:[CoreDataManager manager]]];
}

- (id <UserDefaultsServiceProtocol>)createUserDefaultsService {
    return [UserDefaultsService createWithTrasport:[LocalTransportLayer managerWithCoreDataManager:[CoreDataManager manager]]];
}

@end
