//
//  Circle.m
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Circle.h"
#import "UIColor+PickerColors.h"


@implementation Circle

- (void)layoutSubviews {
    self.layer.cornerRadius = 5.0;
}

- (void)configureWithState:(CircleState)state {
    switch (state) {
        case EmptyRound:
            [self configureWithBackgroundColor:[UIColor backgroundColor]
                                   borderColor:[UIColor grayColor]
                                   borderWidth:1.0];
            break;
            
        case EmptyRoundInfo:
            //FIXME:ADD COLOR
            break;
            
        case Guessed:
            [self configureWithBackgroundColor:[UIColor learntStateColor] borderWidth:0.0];
            break;
            
        case Failed:
            [self configureWithBackgroundColor:[UIColor failedStateColor] borderWidth:0.0];
            break;
            
        default:
            break;
    }
}

- (void)configureWithBackgroundColor:(UIColor *)backgroundColor
                         borderColor:(UIColor *)borderColor
                         borderWidth:(CGFloat)borderWidth {
    
    [self configureWithBackgroundColor:backgroundColor borderWidth:borderWidth];
    self.layer.borderColor = borderColor.CGColor;
}

- (void)configureWithBackgroundColor:(UIColor *)backgroundColor
                         borderWidth:(CGFloat)borderWidth {
    
    self.backgroundColor = backgroundColor;
    self.layer.borderWidth = borderWidth;
}

@end
