//
//  LocalTransportLayer.h
//  Memento
//
//  Created by Andrey Morozov on 29.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportLayerProtocol.h"

@class CoreDataManager;

@interface LocalTransportLayer : NSObject <TransportLayerProtocol>

+ (instancetype)managerWithCoreDataManager:(CoreDataManager *)coreDataManager;

@end
