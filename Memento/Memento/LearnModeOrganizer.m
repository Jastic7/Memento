//
//  LearnModeOrganizer.m
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnModeOrganizer.h"
#import "Set.h"

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

@property (nonatomic, assign, readonly) BOOL isEnoughItems;

@end


@implementation LearnModeOrganizer


#pragma mark - Getters

- (Set *)roundSet {
    if (!_roundSet) {
        _roundSet = [Set new];
    }
    
    return _roundSet;
}

- (BOOL)isEnoughItems {
    return self.location + kCountItemsInRound < self.learningSet.count;
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
    [self.delegate showNewTerm:roundItem.term withLearnProgress:roundItem.learnProgress];
}

- (void)setCurrentRound:(NSUInteger)currentRound {
    _currentRound = currentRound;
    //FIXME:Call another method
    [self.delegate finishLearning];
}


#pragma mark - Helpers

- (void)updateLearningProgressOfItem:(ItemOfSet *)item isUserRight:(BOOL)isCorrectDefinition {
    if (isCorrectDefinition) {
        [item increaseLearnProgress];
    } else {
        [item resetLearnProgress];
    }
}



#pragma mark - LearnModeProtocol implementation

- (void)setInitialConfiguration {
    self.location = 0;
    self.currentRound = 0;
}

#pragma mark - Updating

- (void)updateRoundSet {
    if (self.location > self.learningSet.count) {
        [self.delegate finishLearning];
        
        return;
    }
    
    //creates the new range for current round.
    NSUInteger length = self.isEnoughItems ? kCountItemsInRound : self.learningSet.count - self.location;
    NSRange range = NSMakeRange(self.location, length);
    self.location += length;
    
    //fills round set by new items.
    self.roundSet = [self.learningSet subsetWithRange:range];
    self.roundItemIndex = 0;
}

- (void)updateLearningItem {
    self.roundItemIndex++;
}

#pragma mark - Initialization

- (instancetype)initWithSet:(Set *)set {
    self = [super init];
    
    if (self) {
        _set = set;
        _learningSet = [Set setWithSet:set];
    }
    
    return self;
}

+ (instancetype)createWithSet:(Set *)set {
    return [[self alloc] initWithSet:set];
}


#pragma mark - Checking

- (LearnState)checkUserDefinition:(NSString *)definition {
    BOOL isCorrectDefinition = [self.roundItem.definition isEqualToString:definition];
    
    [self updateLearningProgressOfItem:self.roundItem isUserRight:isCorrectDefinition];
    
    if (self.roundItem.learnProgress == Learnt) {
        [self.learningSet addItem:self.roundItem];
    }
    
    return self.roundItem.learnProgress;
}

- (void)dealloc {
    NSLog(@"ORGINIZER LEFT");
}

@end
