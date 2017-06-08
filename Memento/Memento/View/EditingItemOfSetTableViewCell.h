//
//  EditingItemOfSetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingItemOfSetTableViewCell : UITableViewCell

@property (nonatomic, weak) id <UITextViewDelegate> delegate;

+ (UINib *)nib;

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition;

@end
