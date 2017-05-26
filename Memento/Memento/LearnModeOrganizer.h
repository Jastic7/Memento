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

- (void)didFinishLearning;
- (void)didUpdatedTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress;
- (void)didCheckedUserDefinitionWithLearningState:(LearnState)learnProgress previousState:(LearnState)previousProgress;

@end


@interface LearnModeOrganizer : NSObject <LearnModeProtocol>

@property (nonatomic, strong) Set *set;
@property (nonatomic, strong) Set *learningSet;
@property (nonatomic, strong, readonly) Set *roundSet;

@property (nonatomic, assign, readonly) BOOL isLearningFinished;

@property (nonatomic, weak) id <LearnModeOrganizerDelegate> delegate;

@end
