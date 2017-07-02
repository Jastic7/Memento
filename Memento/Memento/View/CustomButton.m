//
//  CustomButton.m
//  Memento
//
//  Created by Andrey Morozov on 02.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "CustomButton.h"
#import "UIColor+PickerColors.h"
@implementation CustomButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.backgroundColor = highlighted ? [UIColor buttonPressedBackgroundColorWithAplha:self.alpha] : [UIColor buttonBackroundColorWithAplha:self.alpha];
}

@end
