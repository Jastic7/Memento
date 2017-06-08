//
//  AuthenticationDelegate.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AuthenticationDelegate <NSObject>

- (void)authenticationDidCancelled;
- (void)authenticationDidComplete;

@end
