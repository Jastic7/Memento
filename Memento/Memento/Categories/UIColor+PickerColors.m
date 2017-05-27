//
//  UIColor+PickerColors.m
//  Memento
//
//  Created by Andrey Morozov on 24.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UIColor+PickerColors.h"

@implementation UIColor (PickerColors)

+ (instancetype)fernColor {
    return [UIColor colorWithRed:64/255.0 green:128/255.0 blue:0.0 alpha:1.0];
}

+ (instancetype)mercuryColor {
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
}

+ (instancetype)unknownColor {
    return [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
}

+ (instancetype)failedColor {
    return [UIColor colorWithRed:149/255.0 green:30/255.0 blue:23/255.0 alpha:1.0];
}

+ (instancetype)deepBlue {
    return [UIColor colorWithRed:0/255.0 green:64/255.0 blue:128/255.0 alpha:1.0];
}

+ (instancetype)textBlack {
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}

@end



