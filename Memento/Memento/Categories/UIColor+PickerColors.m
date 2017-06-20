//
//  UIColor+PickerColors.m
//  Memento
//
//  Created by Andrey Morozov on 24.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UIColor+PickerColors.h"

@implementation UIColor (PickerColors)

+ (instancetype)backgroundColor {
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
}

+ (instancetype)buttonBackroundColor {
    return [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
}


#pragma mark - LearnProgress colors.

+ (instancetype)learntStateColor {
    return [UIColor colorWithRed:64/255.0 green:128/255.0 blue:0.0 alpha:1.0];
}

+ (instancetype)unknownStateColor {
    return [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
}

+ (instancetype)failedStateColor {
    return [UIColor colorWithRed:149/255.0 green:30/255.0 blue:23/255.0 alpha:1.0];
}

+ (instancetype)deepBlue {
    return [UIColor colorWithRed:0/255.0 green:64/255.0 blue:128/255.0 alpha:1.0];
}

+ (instancetype)textColor {
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}

@end



