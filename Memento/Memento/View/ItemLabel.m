//
//  ItemLabel.m
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemLabel.h"

@implementation ItemLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 8, 0, 0);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
