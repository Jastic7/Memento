//
//  ItemLabel.m
//  Memento
//
//  Created by Andrey Morozov on 26.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemLabel.h"

@implementation ItemLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 8, 0, 0);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
