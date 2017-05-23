//
//  LearnModeOrganizer.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LearnModeProtocol.h"

static NSUInteger const kCountItemsInRound = 7;


@protocol LearnModeOrganizerDelegate <NSObject>

- (void)finishLearning;
- (void)updateTerm:(NSString *)term;

@end


@interface LearnModeOrganizer : NSObject <LearnModeProtocol>

@property (nonatomic, strong) Set *learningSet;
@property (nonatomic, strong, readonly) Set *roundSet;

@property (nonatomic, weak) id <LearnModeOrganizerDelegate> delegate;

@end
