//
//  ItemOfMatchCollectionViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfMatchCollectionViewCell.h"


@interface ItemOfMatchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation ItemOfMatchCollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.backgroundColor = selected ? [UIColor yellowColor] : [UIColor lightGrayColor];
}

- (void)configureWithText:(NSString *)text {
    self.textLabel.text = text;
}

@end
