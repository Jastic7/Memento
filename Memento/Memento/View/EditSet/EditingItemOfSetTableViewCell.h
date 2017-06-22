//
//  NewEditingItemOfSetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditingItemOfSetTableViewCell;

@protocol EditingItemOfSetTableViewCellDelegate <NSObject>

- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didChangeItemInTextView:(UITextView *)textView;
- (void)editingItemOfSetCell:(EditingItemOfSetTableViewCell *)cell didEndEditingItemInTextView:(UITextView *)textView;

@end


@interface EditingItemOfSetTableViewCell : UITableViewCell

@property (nonatomic, weak) id <EditingItemOfSetTableViewCellDelegate> delegate;

+ (UINib *)nib;

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition;
- (void)becomeActive;
@end
