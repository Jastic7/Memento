//
//  ItemOfSetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 05.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemOfSetTableViewCell;

typedef void (^SpeakerHandler)(NSString *term, NSString *definition, ItemOfSetTableViewCell *cell);

@interface ItemOfSetTableViewCell : UITableViewCell

+ (UINib *)nib;

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
           speakerHandler:(SpeakerHandler)handler;

- (void)configureWithTerm:(NSString *)term
               definition:(NSString *)definition
                textColor:(UIColor *)textColor
           speakerHandler:(SpeakerHandler)handler;

- (void)activateSpeaker;
- (void)inactivateSpeaker;

@end
