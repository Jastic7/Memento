//
//  MatchModeOrganizer.h
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchOrganizerProtocol.h"

static NSUInteger const kCountItemsInMatchRound = 6;

@interface MatchOrganizer : NSObject <MatchOrganizerProtocol>

@end
