//
//  LearnProgressStackView.h
//  Memento
//
//  Created by Andrey Morozov on 24.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemOfSet.h"
#import "Circle.h"

@interface LearnProgressStackView : UIStackView

@property (nonatomic, weak) IBOutlet Circle *leftCirle;
@property (nonatomic, weak) IBOutlet Circle *rightCirle;
@property (nonatomic, assign) LearnState learnState;


- (void)setLearnState:(LearnState)learnState;

@end
