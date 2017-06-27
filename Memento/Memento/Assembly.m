//
//  Assembly.m
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Assembly.h"
#import "ServiceLocator.h"
#import "RemoteServiceFactory.h"
#import "AlertFactory.h"
#import "AlertPresenter.h"

@implementation Assembly

+ (void)assemblyServiceLayer {
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator setServiceFactory:[RemoteServiceFactory new]];
}

+ (id <AlertPresenterProtocol>)assembledAlertPresenter {
    AlertPresenter *alertPresenter = [AlertPresenter new];
    [alertPresenter setAlertFactory:[AlertFactory new]];
    
    return alertPresenter;
}

@end
