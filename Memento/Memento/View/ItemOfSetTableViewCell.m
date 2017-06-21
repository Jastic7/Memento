//
//  ItemOfSetTableViewCell.m
//  Memento
//
//  Created by Andrey Morozov on 05.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemOfSetTableViewCell.h"
#import "UIColor+PickerColors.h"

@interface ItemOfSetTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *termLabel;
@property (nonatomic, weak) IBOutlet UILabel *definitionLabel;
@property (nonatomic, weak) IBOutlet UIView *speakerView;
@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;

@property (nonatomic, copy) void (^speakerHandler)(NSString *term, NSString *definition);

@end


@implementation ItemOfSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Helper.

+ (UINib *)nib {
    return [UINib nibWithNibName:@"ItemOfSetTableViewCell" bundle:nil];
}


#pragma mark - Configuration

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
           speakerHandler:(void (^)(NSString *term, NSString *definition))speakerHandler {
    [self configureWithTerm:term definition:definition textColor:[UIColor textColor] speakerHandler:speakerHandler];
}

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
                textColor:(UIColor *)textColor
           speakerHandler:(void (^)(NSString *term, NSString *definition))speakerHandler{
    
    self.termLabel.text             = term;
    self.definitionLabel.text       = definition;
    
    self.termLabel.textColor        = textColor;
    self.definitionLabel.textColor  = textColor;
    
    self.speakerHandler = speakerHandler;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(handleTap:)];
    [self.speakerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.speakerImageView.backgroundColor = [UIColor buttonBackroundColor];
    }];
    
    NSString *term = self.termLabel.text;
    NSString *definition = self.definitionLabel.text;
    
    self.speakerHandler(term, definition);
}

@end
