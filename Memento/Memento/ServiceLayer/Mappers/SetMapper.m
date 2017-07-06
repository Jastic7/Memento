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

@interface SetMapper ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation SetMapper

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    }
    return _dateFormatter;
}

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *author            = json[@"author"];
    NSString *definitionLang    = json[@"definitionLang"];
    NSString *termLang          = json[@"termLang"];
    NSString *title             = json[@"title"];
    NSString *identifier        = json[@"identifier"];
    NSDate   *creationDate      = [self.dateFormatter dateFromString:json[@"creationDate"]];
    
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    NSMutableArray <ItemOfSet *> *items = (NSMutableArray <ItemOfSet *> *)[itemMapper modelsFromJsonOfListObject:json[@"items"]];
    
    return [Set setWithTitle:title author:author definitionLang:definitionLang termLang:termLang identifier:identifier creationDate:creationDate items:items];
}


- (NSDictionary *)jsonFromModel:(id)model {
    ItemOfSetMapper *itemMapper = [ItemOfSetMapper new];
    
    NSDate *creationDate = [model valueForKey:@"creationDate"];
    NSDictionary *items = [itemMapper jsonFromModelArray:[model valueForKey:@"items"]];
    NSDictionary *jsonModel = @{ @"author"          : [model valueForKey:@"author"],
                                 @"definitionLang"  : [model valueForKey:@"definitionLang"],
                                 @"termLang"        : [model valueForKey:@"termLang"],
                                 @"title"           : [model valueForKey:@"title"],
                                 @"items"           : items,
                                 @"identifier"      : [model valueForKey:@"identifier"],
                                 @"creationDate"    : [self.dateFormatter stringFromDate:creationDate]};
    
    return jsonModel;
}

@end
