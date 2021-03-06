//
//  BaseMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "BaseMapper.h"


@implementation BaseMapper

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    return nil;
}

- (NSMutableArray<id> *)modelsFromJsonOfListObject:(NSDictionary *)json {
    NSMutableArray <id> *objectList = [NSMutableArray array];
    
    for (NSString *key in json) {
        NSDictionary *jsonOfObject = [json objectForKey:key];
        id object = [self modelFromJsonOfObject:jsonOfObject];
        
        [objectList addObject:object];
    }
    
    return objectList;
}


- (NSDictionary *)jsonFromModel:(id)model {
    return nil;
}

- (NSDictionary *)jsonFromModelArray:(NSArray *)models {
    NSString *uniqueId;
    NSMutableDictionary *jsonModels = [NSMutableDictionary dictionary];
    
    for (id model in models) {
        uniqueId = [model valueForKey:@"identifier"];
        NSDictionary *json = [self jsonFromModel:model];
        
        jsonModels[uniqueId] = json;
    }
    
    return jsonModels;
}

@end
