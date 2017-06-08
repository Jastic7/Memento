//
//  ItemOfSetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 05.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemOfSetTableViewCell : UITableViewCell

+ (UINib *)nib;

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition;

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
                textColor:(UIColor *)textColor;

@end
