//
//  MatchModeOrganizer.m
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchOrganizer.h"
#import "Set.h"
#import "NSMutableArray+Shuffle.h"


@interface MatchOrganizer ()

@property (nonatomic, strong) Set *set;
@property (nonatomic, strong) Set *matchingSet;
@property (nonatomic, strong) Set *roundSet;

@end


@implementation MatchOrganizer

@synthesize delegate = _delegate;

#pragma mark - Getters

- (Set *)roundSet {
    if (!_roundSet) {
        _roundSet = [Set new];
    }
    
    return _roundSet;
}

- (Set *)set {
    return _set;
}

- (BOOL)isFinished {
    return self.matchingSet.isEmpty;
}


#pragma mark - Initialization

- (instancetype)initWithSet:(Set *)set {
    self = [super init];
    
    if (self) {
        _set = set;
        _matchingSet = [Set setWithSet:set];
    }
    
    return self;
}

+ (instancetype)createWithSet:(Set *)set {
    return [[self alloc] initWithSet:set];
}


#pragma mark - MatchOrganizerProtocol Implementation

- (void)updateRoundSet {
    if (self.isFinished) {
        [self.delegate matchOrganizerDidFinishedMatching:self];
    }
    
    NSUInteger randomIndex;
    ItemOfSet *randomItem;
    
    NSMutableArray<NSString *> *randomItems = [NSMutableArray array];
    
    //get 6 items for current round from set by random.
    for (int i = 0; i < kCountItemsInMatchRound && !self.matchingSet.isEmpty; i++) {
        randomIndex = arc4random() % self.matchingSet.count;
        randomItem = self.matchingSet[randomIndex];
        
        [self.roundSet addItem:randomItem];
        
        [randomItems addObject:randomItem.term];
        [randomItems addObject:randomItem.definition];
        
        [self.matchingSet removeItemAtIndex:randomIndex];
    }
    
    [randomItems shuffle];
    [self.delegate matchOrganizer:self didObtainedRandomItems:randomItems];
}


- (void)checkSelectedItems:(NSArray<NSString *> *)selectedItems {
    BOOL isMatched = NO;
    
    NSString *firstSelectedItem = selectedItems[0];
    NSString *secondSelectedItem = selectedItems[1];
    
    ItemOfSet *checkingItem = [ItemOfSet itemOfSetWithTerm:firstSelectedItem definition:secondSelectedItem];
    isMatched = [self.roundSet containsItem:checkingItem];
    
    if (!isMatched) {
        checkingItem = [ItemOfSet itemOfSetWithTerm:secondSelectedItem definition:firstSelectedItem];
        isMatched = [self.roundSet containsItem:checkingItem];
    }
    
    if (isMatched) {
        [self.roundSet removeItem:checkingItem];
    }
    
    [self.delegate matchOrganizer:self didCheckedSelectedItemsWithResult:isMatched];
}


#pragma mark - Helpers

- (void)reset {
    [self.roundSet removeAllItems];
    self.matchingSet = [Set setWithSet:self.set];
}

@end
