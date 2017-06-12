//
//  MatchModeProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizerProtocol.h"


@protocol MatchOrganizerDelegate <NSObject>

- (void)roundSet:(Set *)roundSet didFilledWithRandomItems:(NSMutableArray <NSString *> *)randomItems;
- (void)didFinishedMatching;
- (void)didCheckedSelectedItemsWithResult:(BOOL)isMatched;

@end


@protocol MatchOrganizerProtocol <OrganizerProtocol>

- (void)checkSelectedItems:(NSArray <NSString *> *)selectedItems;
- (void)setDelegate:(id <MatchOrganizerDelegate>) delegate;

@end
