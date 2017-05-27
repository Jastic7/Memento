//
//  OrganizerProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 27.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;


@protocol OrganizerProtocol <NSObject>

/**
 * @brief Get general selected set for some mode.
 * @return Initial selected set.
 */
- (Set *)set;

/**
 * @brief Get set, which configuring for each round in some mode.
 * @return Set for each new round.
 */
- (Set *)roundSet;

/**
 * @brief Initialize organizers set with data from another set.
 * @param set - Data for initialization.
 * @return New initialized organizer.
 */
- (instancetype)initWithSet:(Set *)set;

/**
 * @brief Create new organizer with data from anodther set.
 * @param set - Data for initialization.
 * @return New created organizer.
 */
+ (instancetype)createWithSet:(Set *)set;

/**
 * @brief Determine state of organizers mode.
 * @return True if some mode is finished. False otherwise.
 */
- (BOOL) isFinished;

/**
 * @brief Update items in roundSet.
 */
- (void)updateRoundSet;

/**
 * @brief Reset all properties for mode restart.
 */
- (void)reset;

@end
