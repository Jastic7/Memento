//
//  SetMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SetMapper.h"
#import "ItemsOfSetMapper.h"
#import "Set.h"


@implementation SetMapper

- (Set *)modelFromJsonOfSet:(NSDictionary *)json {
    NSString *author            = json[@"author"];
    NSString *definitionLang    = json[@"definitionLang"];
    NSString *termLang          = json[@"termLang"];
    NSString *title             = json[@"setTitle"];
    
    ItemsOfSetMapper *itemMapper = [ItemsOfSetMapper new];
    
    NSMutableArray <ItemOfSet *> *items = [itemMapper modelsFromJsonOfListItems:json[@"items"]];
    
    Set *set = [Set setWithTitle:title author:author definitionLang:definitionLang termLang:termLang items:items];
    
    return set;
}

- (NSMutableArray<Set *> *)modelsFromJsonOfListSet:(NSDictionary *)json {
    NSMutableArray <Set *> *setList = [NSMutableArray array];
    
    for (NSString *key in json) {
        NSDictionary *jsonOfSet = [json objectForKey:key];
        Set *set = [self modelFromJsonOfSet:jsonOfSet];
        
        [setList addObject:set];
    }
    
    return setList;
}

@end
