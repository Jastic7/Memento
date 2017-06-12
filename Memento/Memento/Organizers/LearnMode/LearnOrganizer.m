//
//  LearnModeOrganizer.m
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnOrganizer.h"
#import "Set.h"

@interface LearnOrganizer ()

@property (nonatomic, strong) Set *set;
@property (nonatomic, strong) Set *learningSet;

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
 * learning set. It is being used for creation
 * new subset in the new round.
 */
@property (nonatomic, assign) NSUInteger location;

/*!
 * @brief Responsible for tracking index of learning
 * item from roundSet.
 */
@property (nonatomic, assign) NSUInteger learningItemIndex;

/*!
 * @brief Current learning item from roundSet in current round.
 */
@property (nonatomic, strong) ItemOfSet *learningItem;

/*!
 * @brief True if roundSet has no less items than items needs
 * per round. False - otherwise.
 */
@property (nonatomic, assign, readonly) BOOL isEnoughItems;

@end


@implementation LearnOrganizer

@synthesize delegate = _delegate;

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

- (BOOL)isFinished {
    return self.location > self.learningSet.count;
}

- (Set *)set {
    return _set;
}

#pragma mark - Setters

- (void)setLearningItemIndex:(NSUInteger)learningItemIndex {
    _learningItemIndex = learningItemIndex;
    
    if (_learningItemIndex == self.roundSet.count) {
        self.currentRound++;
    } else {
        self.learningItem = self.roundSet[_learningItemIndex];
    }
}

- (void)setLearningItem:(ItemOfSet *)roundItem {
    _learningItem = roundItem;
    
    [self.delegate learnOrganizer:self didUpdatedTerm:roundItem.term withLearnProgress:roundItem.learnProgress];
}

- (void)setCurrentRound:(NSUInteger)currentRound {
    _currentRound = currentRound;

    [self.delegate learnOrganizer:self didFinishedRound:currentRound];
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


#pragma mark - LearnModeProtocol implementation

- (void)setInitialConfiguration {
    self.location = 0;
    self.currentRound = 0;
}

- (void)reset {
    [self.set resetAllLearnProgress];
    
    self.learningSet = [Set setWithSet:self.set];
    
    self.location = 0;
    _currentRound = 0;
}

#pragma mark - Updating

- (void)updateRoundSet {
    if ([self isFinished]) {
        [self.delegate learnOrganizer:self didFinishedRound:self.currentRound];
    } else {
        //creates the new range for current round.
        NSUInteger length = self.isEnoughItems ? kCountItemsInRound : self.learningSet.count - self.location;
        NSRange range = NSMakeRange(self.location, length);
        self.location += length;
        
        //fills round set by new items.
        self.roundSet = [self.learningSet subsetWithRange:range];
        self.learningItemIndex = 0;
    }
}

- (void)updateLearningItem {
    self.learningItemIndex++;
}


#pragma mark - Checking

- (void)checkUserDefinition:(NSString *)definition {
    BOOL isCorrectDefinition = [self.learningItem.definition isEqualToString:definition];
    
    LearnState previousState = self.learningItem.learnProgress;
    [self updateLearningProgressOfItem:self.learningItem isUserRight:isCorrectDefinition];
    
    if (self.learningItem.learnProgress == Unknown || self.learningItem.learnProgress == Learnt) {
        [self.learningSet addItem:self.learningItem];
    }
    
    LearnState itemLearnProgress = self.learningItem.learnProgress;
    [self.delegate learnOrganizer:self didCheckedDefinitionWithLearningState:itemLearnProgress previousState:previousState];
}


#pragma mark - Helpers

- (void)updateLearningProgressOfItem:(ItemOfSet *)item isUserRight:(BOOL)isCorrectDefinition {
    if (isCorrectDefinition) {
        [item increaseLearnProgress];
    } else {
        [item failLearnProgress];
    }
}
- (void)dealloc {
    NSLog(@"ORGANIZER LEFT");
}

@end
