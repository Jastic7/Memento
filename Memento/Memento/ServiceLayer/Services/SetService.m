//
//  SetService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "TransportLayer.h"
#import "SetService.h"
#import "Set.h"
#import "SetMapper.h"

@implementation SetService

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceCompletionBlock)completion {
    SetMapper *setMapper = [SetMapper new];
    
    if (uid) {
        [self.transort obtainSetListWithPath:@"setList/" fromUserWithId:uid success:^(id response) {
            
            NSMutableArray <Set *> *listSet;
            if (response) {
                 listSet = [setMapper modelsFromJsonOfListSet:response];
            }
            
            completion(listSet, nil);
            
        } failure:^(NSError *error) {
            NSLog(@"FAILURE");
        }];
    }
    
}

@end
