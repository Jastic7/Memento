//
//  ServiceLocator.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ServiceLocator.h"
#import "ServiceFactoryProtocol.h"

static ServiceLocator *sharedInstance = nil;


@interface ServiceLocator ()

@property (nonatomic, strong) id <ServiceFactoryProtocol> serviceFactory;

@property (nonatomic, strong) id <AuthServiceProtocol> authService;
@property (nonatomic, strong) id <SetServiceProtocol>  setService;
@property (nonatomic, strong) id <UserServiceProtocol> userService;
@property (nonatomic, strong) id <SpeechServiceProtocol> speechService;
@property (nonatomic, strong) id <UserDefaultsServiceProtocol> userDefualtsService;

@end


@implementation ServiceLocator

#pragma mark - Getters

- (id <AuthServiceProtocol>)authService {
    if (!_authService) {
        _authService = [self.serviceFactory createAuthService];
    }
    
    return _authService;
}

- (id <SetServiceProtocol>)setService {
    if (!_setService) {
        _setService = [self.serviceFactory createSetService];
    }
    
    return _setService;
}

- (id <UserServiceProtocol>)userService {
    if (!_userService) {
        _userService = [self.serviceFactory createUserService];
    }
    
    return _userService;
}

- (id <SpeechServiceProtocol>)speechService {
    if (!_speechService) {
        _speechService = [self.serviceFactory createSpeechService];
    }
    
    return _speechService;
}

- (id <UserDefaultsServiceProtocol>)userDefaultsService {
    if (!_userDefualtsService) {
        _userDefualtsService = [self.serviceFactory createUserDefaultsService];
    }
    
    return _userDefualtsService;
}


#pragma mark - Setters

- (void)setServiceFactory:(id <ServiceFactoryProtocol>)serviceFactory {
    _serviceFactory = serviceFactory;
}


#pragma mark - Initializations

+ (instancetype)shared {
    return [self sharedService];
}

+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (void)resetServices {
    self.authService = nil;
    self.setService = nil;
    self.userService = nil;
    self.speechService = nil;
    self.userDefualtsService = nil;
}

@end
