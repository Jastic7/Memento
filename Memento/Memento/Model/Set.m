//
//  Set.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Set.h"
#import "ItemOfSet.h"
#import "ServiceLocator.h"

@interface Set ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *termLang;
@property (nonatomic, copy) NSString *definitionLang;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSMutableArray<ItemOfSet *> *items;

@end

@implementation Set


#pragma mark - Initializations

- (instancetype)init {
    return [self initWithTitle:nil author:@"" definitionLang:@"" termLang:@"" items:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
               definitionLang:(NSString *)defLang
                     termLang:(NSString *)termLang
                        items:(NSArray<ItemOfSet *> *)items {
    
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    NSString *identifier = [serviceLocator.authService configureUnuiqueId];
    
    self = [self initWithTitle:title author:author definitionLang:defLang termLang:termLang identifier:identifier creationDate:[NSDate date] items:items];

    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
               definitionLang:(NSString *)defLang
                     termLang:(NSString *)termLang
                   identifier:(NSString *)identifier
                 creationDate:(NSDate   *)creationDate
                        items:(NSArray<ItemOfSet *> *)items {
    
    self = [super init];
    
    if (self) {
        _title = title;
        _author = author;
        _definitionLang = defLang;
        _termLang = termLang;
        _identifier = identifier;
        _items = [NSMutableArray new];
        _creationDate = creationDate;
        
        [self.items addObjectsFromArray:items];
        [self.items sortUsingComparator:^NSComparisonResult(ItemOfSet * _Nonnull obj1, ItemOfSet * _Nonnull obj2) {
            return [obj1.term compare:obj2.term];
        }];
    }
    
    return self;
}

+ (instancetype)setWithTitle:(NSString *)title
                      author:(NSString *)author
              definitionLang:(NSString *)defLang
                    termLang:(NSString *)termLang
                       items:(NSArray<ItemOfSet *> *)items {
    
    return [[self alloc] initWithTitle:title author:author definitionLang:defLang termLang:termLang items:items];
}

+ (instancetype)setWithTitle:(NSString *)title
                      author:(NSString *)author
              definitionLang:(NSString *)defLang
                    termLang:(NSString *)termLang
                  identifier:(NSString *)identifier
                creationDate:(NSDate   *)creationDate
                       items:(NSArray<ItemOfSet *> *)items {
    
    return [[self alloc] initWithTitle:title author:author definitionLang:defLang termLang:termLang identifier:identifier creationDate:creationDate items:items];
}


+ (instancetype)setWithSet:(Set *)set {
    return [[self alloc] initWithTitle:set.title
                                author:set.author
                        definitionLang:set.definitionLang
                              termLang:set.termLang
                            identifier:set.identifier
                          creationDate:set.creationDate
                                 items:set.items];
}


#pragma mark - Getters

- (NSUInteger)count {
    return [self.items count];
}

- (BOOL)isEmpty {
    return self.items.count == 0;
}

- (NSMutableArray<ItemOfSet *> *)items {
    return _items;
}


#pragma mark - Updating

- (void)updateWithTitle:(NSString *)title termLang:(NSString *)termLang defLang:(NSString *)defLang items:(NSMutableArray<ItemOfSet *> *)items {
    self.title = title;
    self.termLang = termLang;
    self.definitionLang = defLang;
    self.items = items;
    
    [self.items sortUsingComparator:^NSComparisonResult(ItemOfSet *  _Nonnull obj1, ItemOfSet *  _Nonnull obj2) {
        return [obj1.term compare:obj2.term];
    }];
}


#pragma mark - Adding

- (void)addItem:(ItemOfSet *)item {
    [self.items addObject:item];
}

- (void)addItemsFromSet:(Set *)set {
    for (ItemOfSet *item in set) {
        if (![self containsItem:item]) {
            [self addItem:item];
        }
    }
}


#pragma mark - Removing

- (void)removeItem:(ItemOfSet *)item {
    [self.items removeObject:item];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
}

- (void)removeAllItems {
    [self.items removeAllObjects];
}


#pragma mark - Filtering

- (void)filterWithPredicate:(NSPredicate *)predicate {
    [self.items filterUsingPredicate:predicate];
}


#pragma mark - Searching

- (BOOL)containsItem:(ItemOfSet *)item {
    return [self.items containsObject:item];
}

- (ItemOfSet *)findItemWithTerm:(NSString *)term definition:(NSString *)definition {
    for (ItemOfSet *item in self.items) {
        if ([item.term isEqualToString:term] && [item.definition isEqualToString:definition]) {
            return item;
        }
    }
    
    return nil;
}


#pragma mark - Sub items

- (Set *)subsetWithRange:(NSRange)range {
    NSArray<ItemOfSet *> *subitems = [self.items subarrayWithRange:range];
    Set *subset = [Set setWithTitle:self.title author:self.author definitionLang:self.definitionLang termLang:self.termLang items:subitems];
    
    return subset;
}


- (NSMutableArray <ItemOfSet *> *)itemsWithLearnState:(LearnState)learnState {
    NSMutableArray <ItemOfSet *> *filteredItems = [NSMutableArray array];
    for (ItemOfSet *item in self.items) {
        if (item.learnProgress == learnState) {
            [filteredItems addObject:item];
        }
    }
    
    return filteredItems;
}


#pragma mark - Count

- (NSUInteger)countItemsWithLearnState:(LearnState)learnState {
    NSUInteger count = 0;
    for (ItemOfSet *item in self.items) {
        if (item.learnProgress == learnState) {
            count++;
        }
    }
    
    return count;
}


#pragma mark - Helpers.

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.items[idx];
}

- (void)resetAllLearnProgress {
    for (ItemOfSet *item in self.items) {
        [item resetLearnProgress];
    }
}


#pragma mark - NSCopying.

- (id)copyWithZone:(NSZone *)zone {
    Set *copySet = [[[self class] allocWithZone:zone] init];
    
    copySet.author          = self.author;
    copySet.title           = self.title;
    copySet.termLang        = self.termLang;
    copySet.definitionLang  = self.definitionLang;
    copySet.creationDate    = self.creationDate;
    
    for (ItemOfSet *item in self.items) {
        [copySet.items addObject:[item copy]];
    }
    
    return copySet;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.items countByEnumeratingWithState:state objects:buffer count:len];
}

@end
