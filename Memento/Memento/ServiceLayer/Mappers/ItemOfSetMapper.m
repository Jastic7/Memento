//
//  ItemsOfSetMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSetMapper.h"
#import "NSString+LearnStateParser.h"


@implementation ItemOfSetMapper


- (id)modelFromJsonOfObject:(NSDictionary *)json {
    NSString *definition = json[@"definition"];
    NSString *term       = json[@"term"];
    NSString *identifier = json[@"identifier"];
    
    LearnState learnProgress = [json[@"learnProgress"] getLearnState];
    
    return [ItemOfSet itemOfSetWithTerm:term definition:definition learnProgress:learnProgress identifier:identifier];
}


- (NSDictionary *)jsonFromModel:(id)model {
    NSNumber *state = [model valueForKey:@"learnProgress"];
    NSString *learnProgress = [NSString stringWithLearnState:state.integerValue];
    
    NSDictionary <NSString *, id> *jsonModel = @{ @"term"           : [model valueForKey:@"term"],
                                                  @"definition"     : [model valueForKey:@"definition"],
                                                  @"learnProgress"  : learnProgress,
                                                  @"identifier"     : [model valueForKey:@"identifier"] };
    
    return jsonModel;
}

@end
