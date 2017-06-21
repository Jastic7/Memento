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
               definition:(NSString *)definition
           speakerHandler:(void (^)(NSString *term, NSString *definition))speakerHandler;

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
                textColor:(UIColor *)textColor
           speakerHandler:(void (^)(NSString *term, NSString *definition))speakerHandler;

@end
