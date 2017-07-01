//
//  Assembly.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertPresenterProtocol;


@interface Assembly : NSObject

+ (void)assemblyLocalServiceLayer;
+ (void)assemblyRemoteServiceLayer;
+ (id <AlertPresenterProtocol>)assembledAlertPresenter;

@end
