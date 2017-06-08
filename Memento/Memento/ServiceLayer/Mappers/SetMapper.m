//
//  SetMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SetMapper.h"
#import "ItemOfSetMapper.h"
#import "Set.h"


@implementation SetMapper

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *author            = json[@"author"];
    NSString *definitionLang    = json[@"definitionLang"];
    NSString *termLang          = json[@"termLang"];
    NSString *title             = json[@"setTitle"];
    NSString *identifier        = json[@"id"];
    
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSMutableArray <ItemOfSet *> *items = (NSMutableArray <ItemOfSet *> *)[itemMapper modelsFromJsonOfListObject:json[@"items"]];
    
    Set *set = [Set setWithTitle:title author:author definitionLang:definitionLang termLang:termLang identifier:identifier items:items];
    
    return set;
}

- (NSDictionary *)jsonFromModel:(id)model {
    Set *set = model;
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSDictionary *items = [itemMapper jsonFromModelArray:set.items];
    NSNumber *itemCount = [NSNumber numberWithUnsignedInteger:set.count];
    
    NSDictionary *jsonModel = @{ @"author"          : set.author,
                                 @"itemCount"       : itemCount,
                                 @"definitionLang"  : set.definitionLang,
                                 @"termLang"        : set.termLang,
                                 @"setTitle"        : set.title,
                                 @"items"           : items,
                                 @"id"              : set.identifier };
    
    return jsonModel;
}

@end
