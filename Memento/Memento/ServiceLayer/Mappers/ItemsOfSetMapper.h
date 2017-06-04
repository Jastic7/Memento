//
//  ItemsOfSetMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemOfSet;

@interface ItemsOfSetMapper : NSObject

- (ItemOfSet *)modelFromJsonOfItem:(NSDictionary *)json;
- (NSMutableArray <ItemOfSet *> *)modelsFromJsonOfListItems:(NSDictionary *)json;

@end
