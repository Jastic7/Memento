//
//  ServiceFactoryProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 01.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthServiceProtocol;


@protocol ServiceFactoryProtocol <NSObject>

- (id <AuthServiceProtocol>)createAuthService;


@end
