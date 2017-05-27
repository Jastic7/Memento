//
//  UITableView+GettingCell.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UITableView+GettingIndexPath.h"

@implementation UITableView (GettingIndexPath)

-(NSIndexPath *)indexPathForSubview:(UIView *)subview {
    CGPoint middlePointOfSubview = CGPointMake(CGRectGetMidX(subview.bounds), CGRectGetMidY(subview.bounds));
    CGPoint middlePointOfSubviewInSuperViewCoordinates = [self convertPoint:middlePointOfSubview fromView:subview];
    
    return [self indexPathForRowAtPoint:middlePointOfSubviewInSuperViewCoordinates];
}

@end
