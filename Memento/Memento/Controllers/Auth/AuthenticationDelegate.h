//
//  AuthenticationDelegate.h
//  Memento
//
//  Created by Andrey Morozov on 08.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AuthenticationDelegate <NSObject>

/*!
 * @brief It should be called, when authentication is cancelled.
 */
- (void)authenticationDidCancelled;

/*!
 * @brief It should be called, when authentication is completed.
 * It means, that the new user is registered or is loggined.
 */
- (void)authenticationDidComplete;

@end
