//
//  ModeProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizerProtocol.h"
#import "ItemOfSet.h"

@protocol LearnModeOrganizerDelegate <NSObject>

- (void)didFinishedLearning;
- (void)didUpdatedTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress;
- (void)didCheckedUserDefinitionWithLearningState:(LearnState)learnProgress previousState:(LearnState)previousProgress;

@end


@protocol LearnModeProtocol <NSObject, OrganizerProtocol>

- (void)setInitialConfiguration;

- (void)checkUserDefinition:(NSString *)definition;
- (void)updateLearningItem;

- (void)setDelegate:(id <LearnModeOrganizerDelegate>)delegate;

@end
