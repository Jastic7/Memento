//
//  ManagedObjectsMapper.m
//  Memento
//
//  Created by Andrey Morozov on 02.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ManagedObjectsMapper.h"
#import "SetMO+CoreDataClass.h"
#import "ItemMO+CoreDataClass.h"

@implementation ManagedObjectsMapper

- (NSDictionary *)jsonFromSetsMO:(NSArray <SetMO *> *)setsMO {
    NSString *uniqueId;
    NSMutableDictionary *jsonModels = [NSMutableDictionary dictionary];
    
    for (SetMO *setMO in setsMO) {
        uniqueId = setMO.identifier;
        NSDictionary *json = [self jsonFromSetMO:setMO];
        
        jsonModels[uniqueId] = json;
    }
    
    return jsonModels;
}

- (NSDictionary *)jsonFromSetMO:(SetMO *)setMO {
    NSDictionary *itemsMO = [self jsonFromItemsMO:setMO.items];
    
    NSDictionary *jsonModel = @{ @"author"          : setMO.author,
                                 @"definitionLang"  : setMO.definitionLang,
                                 @"termLang"        : setMO.termLang,
                                 @"title"           : setMO.title,
                                 @"items"           : itemsMO,
                                 @"identifier"      : setMO.identifier };
    
    return jsonModel;
}

- (NSDictionary *)jsonFromItemsMO:(NSOrderedSet<ItemMO *> *)itemsMO {
    NSString *uniqueId;
    NSMutableDictionary *jsonModels = [NSMutableDictionary dictionary];
    
    for (ItemMO *itemMO in itemsMO) {
        uniqueId = itemMO.identifier;
        NSDictionary *json = [self jsonFromItemMO:itemMO];
        
        jsonModels[uniqueId] = json;
    }
    
    return jsonModels;
}

- (NSDictionary *)jsonFromItemMO:(ItemMO *)itemMO {
    NSDictionary <NSString *, id> *jsonModel = @{ @"term"           : itemMO.term,
                                                  @"definition"     : itemMO.definition,
                                                  @"learnProgress"  : itemMO.learnProgress,
                                                  @"identifier"     : itemMO.identifier };
    
    return jsonModel;
}

@end
