//
//  SetService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "TransportLayer.h"
#import "SetService.h"
#import "SetMapper.h"

@implementation SetService

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceCompletionBlock)completion {
    if (uid) {
        SetMapper *setMapper = [SetMapper new];
        NSString *path = @"sets";
        
        [self.transort obtainDataWithPath:path userId:uid success:^(id response) {
            
            NSMutableArray <Set *> *listSet;
            if (response) {
                 listSet = (NSMutableArray <Set *> *)[setMapper modelsFromJsonOfListObject:response];
            }
            
            completion(listSet, nil);
            
        } failure:^(NSError *error) {
            NSLog(@"FAILURE");
            completion(nil, error);
        }];
    }
}

@end
