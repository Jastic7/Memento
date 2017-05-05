//
//  Set.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemOfSet;

@interface Set : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSMutableArray<ItemOfSet *> *items;
@property (nonatomic, assign, readonly) NSUInteger count;

-(instancetype)initWithTitle:(NSString *)title
                      author:(NSString *)author
                       items:(NSMutableArray<ItemOfSet *> *)items;

+(instancetype)setWithTitle:(NSString *)title
                     author:(NSString *)author
                      items:(NSMutableArray<ItemOfSet *> *)items;

-(void)addItem:(ItemOfSet *)item;
-(void)removeItem:(ItemOfSet *)item;

-(id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
