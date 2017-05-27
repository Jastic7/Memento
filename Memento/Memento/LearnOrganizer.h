//
//  LearnModeOrganizer.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LearnOrganizerProtocol.h"


static NSUInteger const kCountItemsInRound = 7;

@interface LearnOrganizer : NSObject <LearnOrganizerProtocol>

@end
