//
//  UIColor+PickerColors.h
//  Memento
//
//  Created by Andrey Morozov on 24.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PickerColors)

+ (instancetype)backgroundColor;
+ (instancetype)buttonBackroundColorWithAplha:(CGFloat)alpha;
+ (instancetype)buttonPressedBackgroundColorWithAplha:(CGFloat)alpha;

+ (instancetype)learntStateColor;
+ (instancetype)unknownStateColor;
+ (instancetype)failedStateColor;

+ (instancetype)deepBlue;
+ (instancetype)textColor;

@end
