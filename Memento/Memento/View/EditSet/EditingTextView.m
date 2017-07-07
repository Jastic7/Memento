//
//  EditingTextView.m
//  Memento
//
//  Created by Andrey Morozov on 18.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "EditingTextView.h"
#import "UIColor+PickerColors.h"

@interface EditingTextView ()

@property (nonatomic, weak) CALayer *bottomBorder;

@end

@implementation EditingTextView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self registerNotification];
    }
    
    return self;
}


#pragma mark - Layout

- (void)layoutSubviews {
    CGColorRef color = (self.bottomBorder == nil) ? [UIColor textColor].CGColor : self.bottomBorder.backgroundColor;
    [self.bottomBorder removeFromSuperlayer];
    [self addBottomBorderToFrame:self.frame withColor:color];
}


#pragma mark - Helpers

- (void)addBottomBorderToFrame:(CGRect)frame withColor:(CGColorRef)color {
    CALayer *layerBorder = [self createBottomBorderWithHeight:2 toFrame:frame withColor:color];
    
    self.bottomBorder = layerBorder;
    [self.layer addSublayer:layerBorder];
}

- (CALayer *)createBottomBorderWithHeight:(CGFloat)height toFrame:(CGRect)frame withColor:(CGColorRef)color {
    CGRect rect = CGRectMake(0, frame.size.height - height, frame.size.width, height);
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = rect;
    bottomBorder.backgroundColor = color;
    
    return bottomBorder;
}


#pragma mark - Notifications

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidBeginEditing)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidEndEditing)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}

- (void)textDidBeginEditing {
    self.bottomBorder.backgroundColor = [UIColor buttonBackroundColorWithAplha:1.0].CGColor;
}

- (void)textDidEndEditing {
    self.bottomBorder.backgroundColor = [UIColor textColor].CGColor;
}


@end
