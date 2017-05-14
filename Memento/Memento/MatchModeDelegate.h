//
//  MatchModeDelegate.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MatchModeDelegate <NSObject>

- (void)exitMatchMode;
- (void)finishedMatchMode;

@end
