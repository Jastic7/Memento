//
//  BaseService.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TransportLayerProtocol;


@interface BaseService : NSObject

@property (nonatomic, strong, readonly) id <TransportLayerProtocol> transort;

- (instancetype)initWithTrasport:(id <TransportLayerProtocol>)transport;
+ (instancetype)createWithTrasport:(id <TransportLayerProtocol>)transport;

@end
