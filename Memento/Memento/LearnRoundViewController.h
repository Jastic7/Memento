//
//  LearnRoundViewController.h
//  Memento
//
//  Created by Andrey Morozov on 18.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Set;
@class LearnModeOrganizer;

@interface LearnRoundViewController : UIViewController

@property (nonatomic, strong) LearnModeOrganizer *organizer;

@property (nonatomic, copy) void (^cancelingBlock)();

@end
