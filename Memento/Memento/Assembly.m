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


@implementation Assembly

+ (void)assemblyServiceLayer {
    ServiceLocator *serviceLocator = [ServiceLocator shared];
    [serviceLocator setServiceFactory:[RemoteServiceFactory new]];
}

@end
