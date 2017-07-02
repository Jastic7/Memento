//
//  Entity.m
//  Memento
//
//  Created by Andrey Morozov on 06.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (BOOL)isEqual:(id)object {
    Entity *another = object;
    
    return [self.identifier isEqualToString:another.identifier];
}

@end
