//
//  NewEditingItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditingItemOfSetTableViewCell.h"
#import "EditingTextView.h"

@interface EditingItemOfSetTableViewCell ()

@property (weak, nonatomic) IBOutlet EditingTextView *termTextView;
@property (weak, nonatomic) IBOutlet EditingTextView *definitionTextView;

@end


@implementation EditingItemOfSetTableViewCell

- (void)setDelegate:(id <UITextViewDelegate>)delegate {
    _delegate = delegate;
    
    self.termTextView.delegate = _delegate;
    self.definitionTextView.delegate = _delegate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"EditingItemOfSetTableViewCell" bundle:nil];
}

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition {
    self.termTextView.text = term;
    self.definitionTextView.text = definition;
}

@end
