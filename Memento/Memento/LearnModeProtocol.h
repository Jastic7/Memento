//
//  ModeProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;
@class ItemOfSet;


@protocol LearnModeProtocol <NSObject>

- (instancetype)initWithSet:(Set *)set;
+ (instancetype)createWithSet:(Set *)set;

- (BOOL)checkUserDefinition:(NSString *)definition;

@end
