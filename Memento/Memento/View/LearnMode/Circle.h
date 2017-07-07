//
//  Circle.h
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CircleState) {
    EmptyRound,
    EmptyRoundInfo,
    Guessed,
    Failed,
};


@interface Circle : UIView

- (void)configureWithState:(CircleState)state;

@end
