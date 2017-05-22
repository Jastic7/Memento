//
//  LearnRoundInfoHeader.h
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnRoundInfoHeader : UITableViewHeaderFooterView

+ (UINib *)nib;

- (void)configureWithTitle:(NSString *)title;

@end
