//
//  RemoteTransportLayer.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportLayerProtocol.h"


@interface RemoteTransportLayer : NSObject <TransportLayerProtocol>

+ (instancetype)manager;

@end
