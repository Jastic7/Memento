//
//  NSString+LearnStateParser.m
//  Memento
//
//  Created by Andrey Morozov on 06.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "NSString+LearnStateParser.h"

@implementation NSString (LearnStateParser)

+ (instancetype)stringWithLearnState:(LearnState)learnState {
    switch (learnState) {
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

- (LearnState)getLearnState {
    if ([self isEqualToString:@"failed"]) {
        return -1;
    } else if ([self isEqualToString:@"unknown"]) {
        return 0;
    } else if ([self isEqualToString:@"learnt"]) {
        return 1;
    } else if ([self isEqualToString:@"mastered"]) {
        return 2;
    } else {
        return 0;
    }
}

@end
