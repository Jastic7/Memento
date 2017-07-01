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
    NSString *title             = json[@"title"];
    NSString *identifier        = json[@"identifier"];
    
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSMutableArray <ItemOfSet *> *items = (NSMutableArray <ItemOfSet *> *)[itemMapper modelsFromJsonOfListObject:json[@"items"]];
    
    return [Set setWithTitle:title author:author definitionLang:definitionLang termLang:termLang identifier:identifier items:items];
}

- (NSDictionary *)jsonFromModel:(id)model {
    
    Set *set = model;
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSDictionary *items = [itemMapper jsonFromModelArray:set.items];
    
    NSDictionary *jsonModel = @{ @"author"          : set.author,
                                 @"definitionLang"  : set.definitionLang,
                                 @"termLang"        : set.termLang,
                                 @"title"           : set.title,
                                 @"items"           : items,
                                 @"identifier"      : set.identifier };
    
    return jsonModel;
}

@end
