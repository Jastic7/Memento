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
#import "Set.h"
#import "ItemOfSetMapper.h"


@implementation SetService

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceDownloadCompletionBlock)completion {
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

- (void)postSetList:(NSArray<Set *> *)setList
             userId:(NSString *)uid
         completion:(SetServiceUploadCompletionBlock)completion {
    
    SetMapper *setMapper = [SetMapper new];
    
    NSDictionary *jsonData = [setMapper jsonFromModelArray:setList];
    NSString *path = @"sets";
    
    [self.transort postData:jsonData databasePath:path userId:uid success:^(id response) {
        completion(nil);
    } failure:^(NSError *error) {
        completion(error);
    }];
}

- (NSString *)configureUnuiqueId {
    return [self.transort uniqueId];
}

@end
