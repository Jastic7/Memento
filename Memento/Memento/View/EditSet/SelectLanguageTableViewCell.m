//
//  SelectLanguageTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 19.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SelectLanguageTableViewCell.h"

@interface SelectLanguageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;

@end


@implementation SelectLanguageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)configureWithLanguage:(NSString *)language {
    self.languageLabel.text = language;
}

@end
