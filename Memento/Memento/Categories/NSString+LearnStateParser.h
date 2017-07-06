//
//  NSString+LearnStateParser.h
//  Memento
//
//  Created by Andrey Morozov on 06.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemOfSet.h"


@interface NSString (LearnStateParser)

+ (instancetype)stringWithLearnState:(LearnState)learnState;
- (LearnState)getLearnState;

@end
