//
//  ItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSetTableViewCell.h"

@interface ItemOfSetTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *termTextView;
@property (weak, nonatomic) IBOutlet UITextView *definitionTextView;


@end

@implementation ItemOfSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(UINib *)nib {
    return [UINib nibWithNibName:@"ItemOfSetTableViewCell" bundle:nil];
}

@end
