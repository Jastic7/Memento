//
//  SetMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;


@interface SetMapper : NSObject

- (Set *)modelFromJsonOfSet:(NSDictionary *)json;
- (NSMutableArray <Set *> *)modelsFromJsonOfListSet:(NSDictionary *)json;


@end
