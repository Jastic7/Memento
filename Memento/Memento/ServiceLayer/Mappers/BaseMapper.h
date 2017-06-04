//
//  BaseMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMapper : NSObject

- (id)modelFromJsonOfObject:(NSDictionary *)json;
- (NSMutableArray <id> *)modelsFromJsonOfListObject:(NSDictionary *)json;

@end
