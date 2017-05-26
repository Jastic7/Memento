//
//  ModeProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemOfSet.h"

@class Set;


@protocol LearnModeProtocol <NSObject>

- (instancetype)initWithSet:(Set *)set;
+ (instancetype)createWithSet:(Set *)set;

- (void)checkUserDefinition:(NSString *)definition;
- (void)updateRoundSet;
- (void)setInitialConfiguration;
- (void)updateLearningItem;
- (void)reset;

@end
