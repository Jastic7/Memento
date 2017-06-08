//
//  BaseMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"


@interface BaseMapper : NSObject

- (id)modelFromJsonOfObject:(NSDictionary *)json;
- (NSMutableArray <id> *)modelsFromJsonOfListObject:(NSDictionary *)json;

- (NSDictionary *)jsonFromModel:(id)model;
- (NSDictionary *)jsonFromModelArray:(NSArray <id> *)models;


@end
