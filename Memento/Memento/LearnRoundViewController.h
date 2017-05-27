//
//  LearnRoundViewController.h
//  Memento
//
//  Created by Andrey Morozov on 18.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearnModeProtocol.h"


@interface LearnRoundViewController : UIViewController

@property (nonatomic, strong) id <LearnModeProtocol> organizer;
@property (nonatomic, copy) void (^cancelingBlock)();

@end
