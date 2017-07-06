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
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSDictionary *items = [itemMapper jsonFromModelArray:[model valueForKey:@"items"]];
    NSDictionary *jsonModel = @{ @"author"          : [model valueForKey:@"author"],
                                 @"definitionLang"  : [model valueForKey:@"definitionLang"],
                                 @"termLang"        : [model valueForKey:@"termLang"],
                                 @"title"           : [model valueForKey:@"title"],
                                 @"items"           : items,
                                 @"identifier"      : [model valueForKey:@"identifier"] };
    
    return jsonModel;
}

@end
