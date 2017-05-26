//
//  MatchModeProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;


@protocol MatchModeProtocol <NSObject>

- (instancetype)initWithSet:(Set *)set;
+ (instancetype)createWithSet:(Set *)set;


@end
