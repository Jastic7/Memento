//
//  LearnModeOrganizer.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LearnModeProtocol.h"
#import "ItemOfSet.h"

static NSUInteger const kCountItemsInRound = 7;


@protocol LearnModeOrganizerDelegate <NSObject>

- (void)finishLearning;
- (void)showNewTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress;

@end


@interface LearnModeOrganizer : NSObject <LearnModeProtocol>

@property (nonatomic, strong) Set *set;
@property (nonatomic, strong) Set *learningSet;
@property (nonatomic, strong, readonly) Set *roundSet;

@property (nonatomic, weak) id <LearnModeOrganizerDelegate> delegate;

@end
