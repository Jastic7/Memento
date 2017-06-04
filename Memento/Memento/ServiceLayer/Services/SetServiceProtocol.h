//
//  SetServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;

typedef void (^SetServiceCompletionBlock)(NSMutableArray <Set *> *setList, NSError *error);

@protocol SetServiceProtocol <NSObject>

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceCompletionBlock)completion;

@end
