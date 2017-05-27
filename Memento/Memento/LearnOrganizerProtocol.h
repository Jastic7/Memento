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

@protocol LearnOrganizerDelegate <NSObject>

- (void)didFinishedLearning;
- (void)didUpdatedTerm:(NSString *)term withLearnProgress:(LearnState)learnProgress;
- (void)didCheckedUserDefinitionWithLearningState:(LearnState)learnProgress previousState:(LearnState)previousProgress;

@end


@protocol LearnOrganizerProtocol <NSObject, OrganizerProtocol>

- (void)setInitialConfiguration;

- (void)checkUserDefinition:(NSString *)definition;
- (void)updateLearningItem;

- (void)setDelegate:(id <LearnOrganizerDelegate>)delegate;

@end
