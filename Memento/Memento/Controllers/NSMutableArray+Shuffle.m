//
//  NSMutableArray+Shuffle.m
//  Memento
//
//  Created by Andrey Morozov on 17.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle {
    NSUInteger count = self.count;
    
    if (count <= 1) {
        return;
    }
    
    NSUInteger exchangeIndex, remainingCount;
    for (NSUInteger i = 0; i < count - 1; i++) {
        remainingCount = count - i;
        exchangeIndex = i + arc4random_uniform((u_int32_t)remainingCount);
        
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
