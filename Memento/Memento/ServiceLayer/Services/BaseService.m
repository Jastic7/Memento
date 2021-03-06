//
//  BaseService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "BaseService.h"


@implementation BaseService

#pragma mark - Initialization

- (instancetype)initWithTrasport:(id <TransportLayerProtocol>)transport {
    self = [super init];
    
    if (self) {
        _transort = transport;
    }
    
    return self;
}

+ (instancetype)createWithTrasport:(id <TransportLayerProtocol>)transport {
    return [[self alloc] initWithTrasport:transport];
}

@end
