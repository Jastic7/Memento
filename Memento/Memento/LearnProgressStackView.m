//
//  LearnProgressStackView.m
//  Memento
//
//  Created by Andrey Morozov on 24.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LearnProgressStackView.h"
#import "Circle.h"


@implementation LearnProgressStackView

- (void)setLearnState:(LearnState)learnState {
    
    switch (learnState) {
        case Unknown:
            [self.leftCirle configureWithState:EmptyRound];
            [self.rightCirle configureWithState:EmptyRound];
            
            break;
            
        case Learnt:
            [self.leftCirle configureWithState:Guessed];
            [self.rightCirle configureWithState:EmptyRound];
            
            break;
            
        case Mastered:
            [self.leftCirle configureWithState:Guessed];
            [self.rightCirle configureWithState:Guessed];
            
        default:
            break;
    }
}

@end
