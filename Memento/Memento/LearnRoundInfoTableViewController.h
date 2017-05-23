//
//  LearnRoundInfoTableViewController.h
//  Memento
//
//  Created by Andrey Morozov on 22.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Set;


@interface LearnRoundInfoTableViewController : UITableViewController

@property (nonatomic, strong) Set *learningSet;
@property (nonatomic, strong) Set *roundSet;

@property (nonatomic, copy) void (^cancelingBlock)();
@property (nonatomic, copy) void (^prepareForNextRoundBlock)();

@end
