//
//  Set.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemOfSet;

@interface Set : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSMutableArray<ItemOfSet *> *items;
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        items:(NSArray<ItemOfSet *> *)items;

+ (instancetype)setWithTitle:(NSString *)title
                      author:(NSString *)author
                       items:(NSArray<ItemOfSet *> *)items;

- (void)addItem:(ItemOfSet *)item;
- (void)removeItem:(ItemOfSet *)item;
- (void)removeItemAtIndex:(NSUInteger)index;

- (BOOL)containsItem:(ItemOfSet *)item;

- (Set *)subsetWithRange:(NSRange)range;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
