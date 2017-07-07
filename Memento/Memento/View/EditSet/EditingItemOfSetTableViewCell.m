//
//  NewEditingItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditingItemOfSetTableViewCell.h"
#import "EditingTextView.h"

@interface EditingItemOfSetTableViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet EditingTextView *termTextView;
@property (weak, nonatomic) IBOutlet EditingTextView *definitionTextView;

@end


@implementation EditingItemOfSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)becomeFirstResponder {
    return [self.termTextView becomeFirstResponder];
}


#pragma mark - Configuration

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition {
    self.termTextView.text = term;
    self.definitionTextView.text = definition;
    
    self.termTextView.delegate = self;
    self.definitionTextView.delegate = self;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self.delegate editingItemOfSetCell:self didChangeItemInTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate editingItemOfSetCell:self didEndEditingItemInTextView:textView];
}


#pragma mark - Helpers

+ (UINib *)nib {
    return [UINib nibWithNibName:@"EditingItemOfSetTableViewCell" bundle:nil];
}

- (void)becomeActive {
    [self.termTextView becomeFirstResponder];
}

@end
