//
//  ItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditingItemOfSetTableViewCell.h"

@interface EditingItemOfSetTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *termTextView;
@property (weak, nonatomic) IBOutlet UITextView *definitionTextView;


@end

@implementation EditingItemOfSetTableViewCell

#pragma mark - Setters

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    _delegate = delegate;
    
    self.termTextView.delegate = self.delegate;
    self.definitionTextView.delegate = self.delegate;
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
