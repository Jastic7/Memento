//
//  ItemsOfSetMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSetMapper.h"
#import "ItemOfSet.h"


@implementation ItemOfSetMapper

- (NSUInteger)parseLearnProgressFromString:(NSString *)string {
    if ([string isEqualToString:@"failed"]) {
        return -1;
    } else if ([string isEqualToString:@"unknown"]) {
        return 0;
    } else if ([string isEqualToString:@"learnt"]) {
        return 1;
    } else if ([string isEqualToString:@"mastered"]) {
        return 2;
    } else {
        return 0;
    }
}

- (NSString *)encodeLearnProgressByState:(LearnState)state {
    switch (state) {
        case Mistake:
            return @"failed";
        case Unknown:
            return @"unknown";
        case Learnt:
            return @"learnt";
        case Mastered:
            return @"mastered";
    }
}

- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *definition = json[@"definition"];
    NSString *term       = json[@"term"];
    NSString *identifier = json[@"id"];
    
    LearnState learnProgress = [self parseLearnProgressFromString:json[@"learnProgress"]];
    
    return [ItemOfSet itemOfSetWithTerm:term definition:definition learnProgress:learnProgress identifier:identifier];
}

- (NSDictionary *)jsonFromModel:(id)model {
    ItemOfSet *item = model;
    NSString *learnProgress = [self encodeLearnProgressByState:item.learnProgress];
    
    NSDictionary <NSString *, id> *jsonModel = @{ @"term"           : item.term,
                                                  @"definition"     : item.definition,
                                                  @"learnProgress"  : learnProgress,
                                                  @"id"             : item.identifier };
    
    return jsonModel;
}

@end
