//
//  SetCollectionViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title termsCount:(NSUInteger)count author:(NSString *)author;

@end
