//
//  ItemOfSet.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSet.h"

@interface ItemOfSet ()

//@property (nonatomic, copy) NSString *term;
//@property (nonatomic, copy) NSString *definition;

@end

@implementation ItemOfSet

#pragma mark - Initializations

- (instancetype)init {
    return [self initWithTerm:@"" definition:@""];
}

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition {
    self = [super init];
    
    if (self) {
        self.term = term;
        self.definition = definition;
    }
    
    return self;
}

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition {
    return [[self alloc] initWithTerm:term definition:definition];
}

-(id)copyWithZone:(NSZone *)zone {
    ItemOfSet *copyItem = [[[self class] allocWithZone:zone] init];
    copyItem.term = self.term;
    copyItem.definition = self.definition;
    
    return copyItem;
}

@end
