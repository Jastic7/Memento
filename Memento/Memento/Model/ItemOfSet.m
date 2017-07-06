//
//  ItemOfSet.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSet.h"
#import "ServiceLocator.h"


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
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    NSString *identifier = [serviceLocator.authService configureUnuiqueId];
    
    return [self initWithTerm:term definition:definition learnProgress:Unknown identifier:identifier];
}

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress identifier:(NSString *)identifier {
    self = [super init];
    
    if (self) {
        _term = term;
        _definition =  definition;
        _learnProgress = progress;
        _identifier = identifier;
    }
    
    return self;
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition {
    return [[self alloc] initWithTerm:term definition:definition];
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress identifier:(NSString *)identifier {
    return [[self alloc] initWithTerm:term definition:definition learnProgress:progress identifier:identifier];
}


#pragma mark - Learn Progress

- (void)failLearnProgress {
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


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone {
    ItemOfSet *copyItem     = [[[self class] allocWithZone:zone] init];
    
    copyItem->_identifier   = self.identifier;
    copyItem.term           = self.term;
    copyItem.definition     = self.definition;
    copyItem.learnProgress  = self.learnProgress;
    
    return copyItem;
}

- (id)valueForKey:(NSString *)key {
    if ([key isEqualToString:@"learnProgress"]) {
        return @(self.learnProgress);
    } else {
        return [super valueForKey:key];
    }
}


@end
