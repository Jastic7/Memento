//
//  SetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SetTableViewCell.h"
#import "UIColor+PickerColors.h"
@interface SetTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countTermsLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIView *setView;

@end

@implementation SetTableViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.setView.backgroundColor = selected ? [UIColor unknownStateColor] : [UIColor whiteColor];
}

- (void)configureWithTitle:(NSString *)title termsCount:(NSUInteger)count author:(NSString *)author {
    self.titleLabel.text = title;
    self.countTermsLabel.text = [NSString stringWithFormat:@"%lu terms", (unsigned long)count];
    self.authorLabel.text = author;
}

@end
