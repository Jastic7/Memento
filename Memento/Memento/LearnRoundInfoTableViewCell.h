//
//  LearnRoundInfoTableViewCell.h
//  Memento
//
//  Created by Andrey Morozov on 23.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnRoundInfoTableViewCell : UITableViewCell

- (void)configureWithTerm:(NSString *)term definition:(NSString *)definition textColor:(UIColor *)textColor;

@end
