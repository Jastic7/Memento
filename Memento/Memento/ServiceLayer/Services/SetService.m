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

@interface SetService ()

@property (nonatomic, copy) NSString *rootPath;

@end


@implementation SetService

- (NSString *)rootPath {
    if (!_rootPath) {
        _rootPath = @"sets";
    }
    
    return _rootPath;
}

- (NSString *)setPathWithUserId:(NSString *)uid {
    NSString *setPathFormat = @"%@/%@";
    NSString *setPath = [NSString stringWithFormat:setPathFormat, self.rootPath, uid];
    
    return setPath;
}

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceDownloadCompletionBlock)completion {
    if (uid) {
        SetMapper *setMapper = [SetMapper new];
        NSString *setPath = [self setPathWithUserId:uid];
        
        [self.transort obtainDataWithPath:setPath success:^(id response) {
            
            NSMutableArray <Set *> *listSet;
            if (response) {
                 listSet = (NSMutableArray <Set *> *)[setMapper modelsFromJsonOfListObject:response];
            }
            
            completion(listSet, nil);
        } failure:^(NSError *error) {
            completion(nil, error);
        }];
    }
}

- (void)postSetList:(NSArray<Set *> *)setList
             userId:(NSString *)uid
         completion:(SetServiceUploadCompletionBlock)completion {
    
    SetMapper *setMapper = [SetMapper new];
    
    NSDictionary *jsonData = [setMapper jsonFromModelArray:setList];
    NSString *setPath = [self setPathWithUserId:uid];
    
    [self.transort postData:jsonData databasePath:setPath completion:completion];
}

- (NSString *)configureUnuiqueId {
    return [self.transort uniqueId];
}

@end
