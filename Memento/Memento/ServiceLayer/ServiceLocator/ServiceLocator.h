//
//  ServiceLocator.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthServiceProtocol.h"

@protocol ServiceFactoryProtocol;


@interface ServiceLocator : NSObject

@property (nonatomic, strong, readonly) id <AuthServiceProtocol> authService;

+ (instancetype)shared;
- (void)setServiceFactory:(id <ServiceFactoryProtocol>)serviceFactory;

@end
