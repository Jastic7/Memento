//
//  MatchModeOrganizer.m
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchModeOrganizer.h"
#import "Set.h"
#import "NSMutableArray+Shuffle.h"


@interface MatchModeOrganizer ()

@property (nonatomic, strong) Set *matchingSet;
@property (nonatomic, strong) Set *roundSet;
@property (nonatomic, strong) NSMutableArray<NSString *> *randomItems;

@end

@implementation MatchModeOrganizer

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

- (void)fillRandomItems {
    if (self.matchingSet.isEmpty) {
        //it means, that user matched all items.
        [self.delegate didFinishedMatching];
    }
    
    NSUInteger randomIndex;
    ItemOfSet *randomItem;
    
    //get 6 items for current round from set by random.
    for (int i = 0; i < 6 && !self.set.isEmpty; i++) {
        randomIndex = arc4random() % self.set.count;
        randomItem = self.set[randomIndex];
        
        [self.roundSet addItem:randomItem];
        
        [self.randomItems addObject:randomItem.term];
        [self.randomItems addObject:randomItem.definition];
        
        [self.matchingSet removeItemAtIndex:randomIndex];
    }
    
    [self.randomItems shuffle];
    [self.delegate roundSet:self.roundSet didFilledWithRandomItems:self.randomItems];
}

@end
