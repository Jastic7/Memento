//
//  ServiceLocator.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthServiceProtocol.h"
#import "SetServiceProtocol.h"
#import "UserServiceProtocol.h"
#import "SpeechServiceProtocol.h"
#import "UserDefaultsServiceProtocol.h"


@protocol ServiceFactoryProtocol;


@interface ServiceLocator : NSObject

@property (nonatomic, strong, readonly) id <AuthServiceProtocol> authService;
@property (nonatomic, strong, readonly) id <SetServiceProtocol>  setService;
@property (nonatomic, strong, readonly) id <UserServiceProtocol> userService;
@property (nonatomic, strong, readonly) id <SpeechServiceProtocol> speechService;
@property (nonatomic, strong, readonly) id <UserDefaultsServiceProtocol> userDefaultsService;

+ (instancetype)shared;
- (void)setServiceFactory:(id <ServiceFactoryProtocol>)serviceFactory;
- (void)resetServices;

@end
