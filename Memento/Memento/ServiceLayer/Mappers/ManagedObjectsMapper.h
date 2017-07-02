//
//  ManagedObjectsMapper.h
//  Memento
//
//  Created by Andrey Morozov on 02.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SetMO;
@class ItemMO;


@interface ManagedObjectsMapper : NSObject

- (NSDictionary *)jsonFromSetsMO:(NSArray <SetMO *> *)setsMO;
- (NSDictionary *)jsonFromSetMO:(SetMO *)setMO;
- (NSDictionary *)jsonFromItemsMO:(NSOrderedSet<ItemMO *> *)itemsMO;
- (NSDictionary *)jsonFromItemMO:(ItemMO *)itemMO;

@end
