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

@end


@implementation ServiceLocator


#pragma mark - Setters

- (void)setServiceFactory:(id<ServiceFactoryProtocol>)serviceFactory {
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


#pragma mark - Implementation

- (id <AuthServiceProtocol>)authService {
    return [self.serviceFactory createAuthService];
}

@end
