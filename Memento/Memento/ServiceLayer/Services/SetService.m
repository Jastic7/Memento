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
#import "ServiceLocator.h"

@interface SetService ()

@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, strong) SetMapper *setMapper;
@property (nonatomic, weak) ServiceLocator *serviceLocator;

@end


@implementation SetService

#pragma mark - Getters

- (NSString *)rootPath {
    if (!_rootPath) {
        _rootPath = @"sets";
    }
    
    return _rootPath;
}

- (SetMapper *)setMapper {
    if (!_setMapper) {
        _setMapper = [SetMapper new];
    }
    
    return _setMapper;
}

- (ServiceLocator *)serviceLocator {
    if (!_serviceLocator) {
        _serviceLocator = [ServiceLocator shared];
    }
    
    return _serviceLocator;
}

#pragma mark - Path Helpers

- (NSString *)setPathWithUserId:(NSString *)uid {
    return [self setPathWithUserId:uid setId:@""];
}

- (NSString *)setPathWithUserId:(NSString *)uid setId:(NSString *)setId {
    NSString *setPathFormat = @"%@/%@/%@";
    NSString *setPath = [NSString stringWithFormat:setPathFormat, self.rootPath, uid, setId];
    
    return setPath;
}


#pragma mark - SetServiceProtocol Implementation

- (void)obtainSetListForUserId:(NSString *)uid completion:(SetServiceDownloadCompletionBlock)completion {
    NSString *setPath = [self setPathWithUserId:uid];
    
    [self.transort obtainDataWithPath:setPath
                              success:^(id response) {
                                  NSMutableArray <Set *> *listSet;
                                  if (response) {
                                      listSet = (NSMutableArray <Set *> *)[self.setMapper modelsFromJsonOfListObject:response];
                                  }
    
                                  completion(listSet, nil);
                              }
                              failure:^(NSError *error) { completion(nil, error);}
     ];
}

- (void)obtainSetListWithCompletion:(SetServiceDownloadCompletionBlock)completion {
    NSString *uid = [self.serviceLocator.userDefaultsService userId];
    [self obtainSetListForUserId:uid completion:completion];
}


- (void)postSetList:(NSArray<Set *> *)setList
             userId:(NSString *)uid
         completion:(SetServiceUploadCompletionBlock)completion {

    for (Set *set in setList) {
        [self postSet:set userId:uid completion:completion];
    }
}

- (void)postSetList:(NSArray<Set *> *)setList completion:(SetServiceUploadCompletionBlock)completion {
    NSString *uid = [self.serviceLocator.userDefaultsService userId];
    [self postSetList:setList userId:uid completion:completion];
}


- (void)postSet:(Set *)set userId:(NSString *)uid completion:(SetServiceUploadCompletionBlock)completion {
    NSDictionary *jsonData = [self.setMapper jsonFromModel:set];
    NSString *setPath = [self setPathWithUserId:uid setId:set.identifier];
    
    [self.transort postData:jsonData databasePath:setPath completion:completion];
}

-(void)postSet:(Set *)set completion:(SetServiceUploadCompletionBlock)completion {
    NSString *uid = [self.serviceLocator.userDefaultsService userId];
    [self postSet:set userId:uid completion:completion];
}

- (NSString *)configureUnuiqueId {
    return [self.transort uniqueId];
}

@end
