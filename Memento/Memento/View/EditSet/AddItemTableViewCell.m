//
//  AddItemTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "AddItemTableViewCell.h"

@implementation AddItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"AddItemTableViewCell" bundle:nil];
}

@end
