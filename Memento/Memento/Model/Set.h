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
@property (nonatomic, copy, readonly)   NSString *definitionLang;
@property (nonatomic, copy, readonly)   NSString *termLang;
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
               definitionLang:(NSString *)defLang
                     termLang:(NSString *)termLang
                        items:(NSArray<ItemOfSet *> *)items;

+ (instancetype)setWithTitle:(NSString *)title
                      author:(NSString *)author
              definitionLang:(NSString *)defLang
                    termLang:(NSString *)termLang
                       items:(NSArray<ItemOfSet *> *)items;

+ (instancetype)setWithSet:(Set *)set;

/*
 * @brief Add new item to the current set items.
 * @param item - The item to be added.
 */
- (void)addItem:(ItemOfSet *)item;

/*
 * @brief Remove item from the current set items.
 * @param item - The item to be removed.
 */
- (void)removeItem:(ItemOfSet *)item;

/*
 * @brief Remove item at index from the current set items.
 * @param index - The index of the item to be removed.
 */
- (void)removeItemAtIndex:(NSUInteger)index;

/*
 * @brief Remove all items from the current set items.
 */
- (void)removeAllItems;


/*
 * @brief Try find the item in the current set items.
 * @param item - The searching item.
 * @param True - if the current set contains the item.
 * False - otherwise.
 */
- (BOOL)containsItem:(ItemOfSet *)item;

/*
 * @brief Get the item with identical term and definition in the current set.
 * @param term - The term of searching item.
 * @param definition - The definition of searching item.
 * @return Item with identical term and definition.
 */
- (ItemOfSet *)findItemWithTerm:(NSString *)term definition:(NSString *)definition;

/*
 * @brief Create subset of the current set with range.
 * @param range - The range if creating items.
 */
- (Set *)subsetWithRange:(NSRange)range;

/*
 * @brief Get items from the current items with identical learnState.
 * @param State of the getting items.
 * @param Items with identical learnState.
 */
- (NSMutableArray <ItemOfSet *> *)itemsWithLearnState:(LearnState)learnState;

/*
 * @brief Get count of items from the current set items with identical learnState.
 * @param LearnState - The state if searching items.
 */
- (NSUInteger)countItemsWithLearnState:(LearnState)learnState;

/*
 * @brief Get item by index.
 * @param idx - Index of getting item.
 */
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

/*
 * @brief Reset learn progress of the all items in the current set.
 */
- (void)resetAllLearnProgress;

@end
