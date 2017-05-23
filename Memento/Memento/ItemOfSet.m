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

@end


@implementation ItemOfSet


#pragma mark - Initializations

- (instancetype)init {
    return [self initWithTerm:@"" definition:@""];
}

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition {
    self = [super init];
    
    if (self) {
        _term = term;
        _definition = definition;
        _learnProgress = Unknown;
    }
    
    return self;
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition {
    return [[self alloc] initWithTerm:term definition:definition];
}


#pragma mark - Learn Progress

- (void)resetLearnProgress {
    self.learnProgress = Unknown;
}

- (void)increaseLearnProgress {
    if (self.learnProgress < 2) {
        self.learnProgress++;
    }
}


#pragma mark - Helpers

- (BOOL)isEqual:(id)object {
    ItemOfSet *anotherObject = object;
    
    return  ([self.term isEqualToString:anotherObject.term]) &&
            ([self.definition isEqualToString:anotherObject.definition]);
}

- (id)copyWithZone:(NSZone *)zone {
    ItemOfSet *copyItem = [[[self class] allocWithZone:zone] init];
    copyItem.term = self.term;
    copyItem.definition = self.definition;
    
    return copyItem;
}

@end
