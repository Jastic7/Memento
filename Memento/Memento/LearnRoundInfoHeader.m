//
//  LearnRoundInfoHeader.m
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnRoundInfoHeader.h"
#import "Circle.h"


@interface LearnRoundInfoHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet Circle *leftCirle;
@property (weak, nonatomic) IBOutlet Circle *rightCircle;

@end

@implementation LearnRoundInfoHeader

+ (UINib *)nib {
    return [UINib nibWithNibName:@"LearnRoundInfoHeader" bundle:nil];
}

- (void)configureWithTitle:(NSString *)title {
    self.titleLabel.text = title;

    if ([title isEqualToString:@"Learnt"]) {
        self.leftCirle.backgroundColor = [UIColor grayColor];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    self.backgroundView = view;
}

@end
