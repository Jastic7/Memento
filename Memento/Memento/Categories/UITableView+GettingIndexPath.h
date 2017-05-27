//
//  UITableView+GettingCell.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (GettingIndexPath)

-(NSIndexPath *)indexPathForSubview:(UIView *)subview;

@end
