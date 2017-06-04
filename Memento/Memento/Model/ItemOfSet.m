//
//  ItemOfSet.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSet.h"

@interface ItemOfSet ()

@property (nonatomic, assign) LearnState learnProgress;
@property (nonatomic, assign) LearnState previousState;

@end


@implementation ItemOfSet


#pragma mark - Settets

- (void)setLearnProgress:(LearnState)learnProgress {
    self.previousState = _learnProgress;
    
    _learnProgress = learnProgress;
}


#pragma mark - Initializations

- (instancetype)init {
    return [self initWithTerm:@"" definition:@""];
}

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition {
    return [self initWithTerm:term definition:definition learnProgress:Unknown];
}

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress {
    self = [super init];
    
    if (self) {
        _term = term;
        _definition = definition;
        _learnProgress = progress;
    }
    
    return self;
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition {
    return [[self alloc] initWithTerm:term definition:definition learnProgress:Unknown];
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress {
    return [[self alloc] initWithTerm:term definition:definition learnProgress:progress];
}


#pragma mark - Learn Progress

-(void)failLearnProgress {
    self.learnProgress = Mistake;
}

- (void)resetLearnProgress {
    self.learnProgress = Unknown;
}

- (void)increaseLearnProgress {
    if (self.learnProgress < 2) {
        self.learnProgress++;
    }
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    ItemOfSet *anotherObject = object;
    
    return  ([self.term isEqualToString:anotherObject.term]) &&
            ([self.definition isEqualToString:anotherObject.definition]);
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone {
    ItemOfSet *copyItem     = [[[self class] allocWithZone:zone] init];
    
    copyItem.term           = self.term;
    copyItem.definition     = self.definition;
    copyItem.learnProgress  = self.learnProgress;
    
    return copyItem;
}

@end
