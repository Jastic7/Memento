//
//  MatchModeOrganizer.h
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchModeProtocol.h"

@protocol MatchModeOrganizerDelegate <NSObject>

- (void) roundSet:(Set *)roundSet didFilledWithRandomItems:(NSMutableArray<NSString *> *)randomItems;
- (void) didFinishedMatching;

@end

@interface MatchModeOrganizer : NSObject <MatchModeProtocol>

@property (nonatomic, strong, readonly) Set *set;
@property (nonatomic, weak) id <MatchModeOrganizerDelegate> delegate;

- (void)fillRandomItems;

@end
