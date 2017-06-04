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

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *author            = json[@"author"];
    NSString *definitionLang    = json[@"definitionLang"];
    NSString *termLang          = json[@"termLang"];
    NSString *title             = json[@"setTitle"];
    
    ItemsOfSetMapper *itemMapper = [ItemsOfSetMapper new];
    
    NSMutableArray <ItemOfSet *> *items = (NSMutableArray <ItemOfSet *> *)[itemMapper modelsFromJsonOfListObject:json[@"items"]];
    
    Set *set = [Set setWithTitle:title author:author definitionLang:definitionLang termLang:termLang items:items];
    
    return set;
}

@end
