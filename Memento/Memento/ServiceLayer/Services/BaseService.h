//
//  BaseService.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransportLayer;


@interface BaseService : NSObject

@property (nonatomic, strong, readonly) TransportLayer *transort;

- (instancetype)initWithTrasport:(TransportLayer *)transport;
+ (instancetype)createWithTrasport:(TransportLayer *)transport;

@end
