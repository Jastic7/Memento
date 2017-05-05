//
//  ItemOfSetTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemOfSetTableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UITextView *termTextView;
@property (weak, nonatomic, readonly) IBOutlet UITextView *definitionTextView;

+(UINib *)nib;

@end
