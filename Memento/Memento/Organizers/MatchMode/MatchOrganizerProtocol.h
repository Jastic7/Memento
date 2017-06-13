//
//  MatchOrganizerProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizerProtocol.h"

@protocol MatchOrganizerProtocol;


@protocol MatchOrganizerDelegate <NSObject>

/*!
 * @brief It is being called, when matching of all items is finished.
 * @param matchOrganizer Match organizer.
 */
- (void)matchOrganizerDidFinishedMatching:(id <MatchOrganizerProtocol>)matchOrganizer;

/*!
 * @brief It is being called, when organizer has filled round set by random items.
 * @param matchOrganizer MatchOrganizer.
 * @param randomItems Array of pairs terms and definitions for round.
 */
- (void)matchOrganizer:(id <MatchOrganizerProtocol>)matchOrganizer
didObtainedRandomItems:(NSMutableArray <NSString *> *)randomItems;

/*!
 * @brief It is being called, when organizer has checked selected items.
 * @param matchOrganizer MatchOrganizer.
 * @param isMatched Result of checking. YES, if selected items are correct, NO - otherwise.
 */
- (void)matchOrganizer:(id <MatchOrganizerProtocol>)matchOrganizer didCheckedSelectedItemsWithResult:(BOOL)isMatched;

@end


@protocol MatchOrganizerProtocol <OrganizerProtocol>

@property (nonatomic, weak) id <MatchOrganizerDelegate> delegate;

/*!
 * @brief Start checking selected items.
 * @param selectedItems Selected items for checking.
 */
- (void)checkSelectedItems:(NSArray <NSString *> *)selectedItems;

@end
