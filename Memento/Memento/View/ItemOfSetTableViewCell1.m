//
//  ItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 05.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSetTableViewCell.h"
#import "UIColor+PickerColors.h"

@interface ItemOfSetTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;

@end


@implementation ItemOfSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"ItemOfSetTableViewCell" bundle:nil];
}

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition {
    [self configureWithTerm:term definition:definition textColor:[UIColor textBlack]];
}

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
                textColor:(UIColor *)textColor {
    
    self.termLabel.text             = term;
    self.definitionLabel.text       = definition;
    
    self.termLabel.textColor        = textColor;
    self.definitionLabel.textColor  = textColor;
}

@end
