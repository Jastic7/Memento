//
//  LearnOrganizerProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizerProtocol.h"
#import "ItemOfSet.h"

@protocol LearnOrganizerProtocol;


@protocol LearnOrganizerDelegate <NSObject>

/*!
 * @brief It is being called, when round is finished.
 * @param learnOrganizer Learn organizer.
 */
- (void)learnOrganizerDidFinishedRound:(id <LearnOrganizerProtocol>)learnOrganizer;

/*!
 * @brief It is being called, when organizer has obtained next item.
 * @param learnOrganizer Learn organizer.
 * @param term Item's term, that should be presented to user.
 * @param learnProgress Learn progress of item's term.
 */
- (void)learnOrganizer:(id <LearnOrganizerProtocol>)learnOrganizer
        didUpdatedTerm:(NSString *)term
     withLearnProgress:(LearnState)learnProgress;

/*!
 * @brief It is being called, when organizer has checked user's answer for current item's term.
 * @param learnOrganizer Learn organizer.
 * @param learnProgress New learn progress of current item.
 * @param previousProgress Previous learn progress of current item.
 */
- (void)learnOrganizer:(id <LearnOrganizerProtocol>)learnOrganizer
didCheckedDefinitionWithLearningState:(LearnState)learnProgress
         previousState:(LearnState)previousProgress;

@end


@protocol LearnOrganizerProtocol <OrganizerProtocol>

@property (nonatomic, weak) id <LearnOrganizerDelegate> delegate;

- (void)setInitialConfiguration;

/*!
 * @brief Check definition and update current learning item's learn progress.
 * @param definition Checking definition for current learning item.
 */
- (void)checkDefinition:(NSString *)definition;

/*!
 * @brief Try select next item to learn from learning set.
 * If learning set is over, then round is being ended.
 */
- (void)selectNextLearningItem;

- (NSString *)getRightAnswer;

@end
