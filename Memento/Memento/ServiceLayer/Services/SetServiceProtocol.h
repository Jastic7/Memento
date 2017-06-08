//
//  SetServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Set;

typedef void (^SetServiceDownloadCompletionBlock)(NSMutableArray <Set *> *setList, NSError *error);
typedef void (^SetServiceUploadCompletionBlock)(NSError *error);


@protocol SetServiceProtocol <NSObject>

- (void)obtainSetListForUserId:(NSString *)uid
                    completion:(SetServiceDownloadCompletionBlock)completion;

- (void)postSetList:(NSArray <Set *> *)setList
             userId:(NSString *)uid
         completion:(SetServiceUploadCompletionBlock)completion;

- (NSString *)configureUnuiqueId;

@end
