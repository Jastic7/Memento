//
//  LearnRoundInfoHeader.m
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundInfoHeader.h"
#import "UIColor+PickerColors.h"
#import "Circle.h"


@interface LearnRoundInfoHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet Circle *leftCircle;
@property (weak, nonatomic) IBOutlet Circle *rightCircle;

@end

@implementation LearnRoundInfoHeader

+ (UINib *)nib {
    return [UINib nibWithNibName:@"LearnRoundInfoHeader" bundle:nil];
}

- (void)configureWithTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor whiteColor];

    if ([title isEqualToString:@"Unknown"]) {
        self.leftCircle.backgroundColor     = [UIColor unknownStateColor];
        self.rightCircle.backgroundColor    = [UIColor unknownStateColor];
        
    } else if ([title isEqualToString:@"Learnt"]) {
        self.leftCircle.backgroundColor     = [UIColor learntStateColor];
        self.rightCircle.backgroundColor    = [UIColor unknownStateColor];
        
    } else if ([title isEqualToString:@"Mastered"]) {
        self.leftCircle.backgroundColor     = [UIColor learntStateColor];
        self.rightCircle.backgroundColor    = [UIColor learntStateColor];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor deepBlue];
    self.backgroundView = view;
}

@end
