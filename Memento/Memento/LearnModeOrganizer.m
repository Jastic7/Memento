//
//  LearnModeOrganizer.m
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnModeOrganizer.h"
#import "Set.h"
#import "ItemOfSet.h"

@interface LearnModeOrganizer ()

/*!
 * @brief Contains items for current learning round.
 */
@property (nonatomic, strong) Set *roundSet;
/*!
 * @brief Responsible for tracking number of rounds.
 */
@property (nonatomic, assign) NSUInteger currentRound;
/*!
 * @brief Responsible for tracking position in whole
 * learning set, which will be using for creating
 * new subset in the new round.
 */
@property (nonatomic, assign) NSUInteger location;
/*!
 * @brief Responsible for tracking index of learning
 * item from the roundSet.
 */
@property (nonatomic, assign) NSUInteger roundItemIndex;
/*!
 * @brief Current item from roundSet in round.
 */
@property (nonatomic, strong) ItemOfSet *roundItem;

@property (nonatomic, assign) BOOL isLastRound;

@end


@implementation LearnModeOrganizer


#pragma mark - Getters

- (Set *)roundSet {
    if (!_roundSet) {
        _roundSet = [Set new];
    }
    
    return _roundSet;
}


#pragma mark - Setters

- (void)setRoundItemIndex:(NSUInteger)roundItemIndex {
    _roundItemIndex = roundItemIndex;
    
    if (_roundItemIndex == self.roundSet.count) {
        self.currentRound++;
        return;
    }
    
    self.roundItem = self.roundSet[_roundItemIndex];
}

- (void)setRoundItem:(ItemOfSet *)roundItem {
    _roundItem = roundItem;
    [self.delegate updateTerm:roundItem.term];
}

- (void)setCurrentRound:(NSUInteger)currentRound {
    _currentRound = currentRound;
    [self updateRoundSet];
}


#pragma mark - Updating

- (void)updateRoundSet {
    if (self.isLastRound) {
        [self.delegate finishLearning];
        return;
    }
    
    //creates the new range for current round.
    self.isLastRound = self.location + kCountItemsInRound >= self.learningSet.count;
    NSUInteger length = self.isLastRound ? self.learningSet.count - self.location : kCountItemsInRound;
    NSRange range = NSMakeRange(self.location, length);
    self.location += length;
    
    //fills round set by new items.
    self.roundSet = [self.learningSet subsetWithRange:range];
    self.roundItemIndex = 0;
    self.roundItem = self.roundSet[self.roundItemIndex];
}

#pragma mark - Helpers

- (void)updateLearningProgressOfItem:(ItemOfSet *)item isUserRight:(BOOL)isUserRight {
    if (isUserRight) {
        [item increaseLearnProgress];
    } else {
        [item resetLearnProgress];
    }
}

- (void)configure {
    self.location = 0;
    self.currentRound = 0;
}

- (void)nextItem {
    self.roundItemIndex++;
}


#pragma mark - LearnModeProtocol implementation

#pragma mark - Initialization

- (instancetype)initWithSet:(Set *)set {
    self = [super init];
    
    if (self) {
        _learningSet = set;
    }
    
    return self;
}

+ (instancetype)createWithSet:(Set *)set {
    return [[self alloc] initWithSet:set];
}


#pragma mark - Checking

- (BOOL)checkUserDefinition:(NSString *)definition {
    BOOL result = [self.roundItem.definition isEqualToString:definition];
    
    [self updateLearningProgressOfItem:self.roundItem isUserRight:result];
    
    return result;
}

- (void)dealloc {
    NSLog(@"ORGINIZER LEFT");
}

@end
