//
//  Set.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemOfSet.h"

@interface Set : NSObject <NSCopying>

@property (nonatomic, copy, readonly)   NSString *title;
@property (nonatomic, copy, readonly)   NSString *author;
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        items:(NSArray<ItemOfSet *> *)items;

+ (instancetype)setWithTitle:(NSString *)title
                      author:(NSString *)author
                       items:(NSArray<ItemOfSet *> *)items;

+ (instancetype)setWithSet:(Set *)set;

- (void)addItem:(ItemOfSet *)item;
- (void)removeItem:(ItemOfSet *)item;
- (void)removeItemAtIndex:(NSUInteger)index;

- (BOOL)containsItem:(ItemOfSet *)item;
- (ItemOfSet *)findItemWithTerm:(NSString *)term definition:(NSString *)definition;

- (Set *)subsetWithRange:(NSRange)range;
- (NSMutableArray <ItemOfSet *> *)itemsWithLearnState:(LearnState)learnState;
- (NSUInteger)countItemsWithLearnState:(LearnState)learnState;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
