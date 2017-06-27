//
//  FeatureView.m
//  Memento
//
//  Created by Andrey Morozov on 27.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "FeatureView.h"

@interface FeatureView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FeatureView

- (void)configureWithTitle:(NSString *)title detailDescription:(NSString *)details imageName:(NSString *)imageName {
    self.titleLabel.text = title;
    self.descriptionLabel.text = details;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
