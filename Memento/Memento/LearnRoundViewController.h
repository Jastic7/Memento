//
//  LearnRoundViewController.h
//  Memento
//
//  Created by Andrey Morozov on 18.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Set;


@interface LearnRoundViewController : UIViewController

@property (nonatomic, strong) Set *learningSet;
@property (nonatomic, copy) void (^cancelingBlock)();

@end
