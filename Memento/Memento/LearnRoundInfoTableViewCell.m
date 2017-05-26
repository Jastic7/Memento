//
//  LearnRoundInfoTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundInfoTableViewCell.h"

@interface LearnRoundInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;

@end

@implementation LearnRoundInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition textColor:(UIColor *)textColor {
    self.termLabel.text             = term;
    self.definitionLabel.text       = definition;
    
    self.termLabel.textColor        = textColor;
    self.definitionLabel.textColor  = textColor;
}


@end
